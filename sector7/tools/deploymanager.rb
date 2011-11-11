#!/usr/bin/env ruby -Ilib/
#
# Copyright 2011, ReportGrid, Inc.

require 'net/http'
require 'uri'
require 'yaml'

require 'rubygems'
require 'json'

# Local includes
$:.push(File.expand_path(File.dirname(__FILE__)) + "/lib")
require 'rg-service'
require 'rg-util'

def file_for (service, source, symlink, mode, alias_ok, root)
  source = File.expand_path(source)
  if not File.readable?(source) then
    puts "Can't read #{source}!"
    exit(-2)
  end

  # Simple sanity check on mode to add a leading zero
  if mode then mode = sprintf("0%3o", mode.oct) end

  # Convert source into an S3 URL
  url = "#{root}#{service}/#{source.split('/').last}"

  # First, check if the file exists
  `s3cmd info #{url} > /dev/null 2>&1`

  if $? == 0 then
    # file exists, but if it's a symlink we can make an alias
    if symlink or alias_ok then
      puts "Aliasing existing URL : #{url}"
      url = "#{url}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
    else
      puts "Can't replace existing file: #{url}"
      exit(-2)
    end
  end

  { "source" => source, "symlink" => symlink, "mode" => mode, "url" => url }.delete_if {|k,v| v == nil}
end

def upload (entry)
  source = entry["source"]
  url = entry["url"]

  # Upload the file
  upload_result = `s3cmd put #{source} #{url}`

  if $? != 0 then
    put "Error uploading #{source}: #{upload_result}"
    exit(-2)
  end

  entry["source"] = url
  entry.delete("url")

  puts "Uploaded #{source} => #{url}"

  entry
end

if ARGV.length < 2 then
  puts "Usage: #{$0} <config file> <command> [<command args>]"
  exit(-1)
end

configFile, command = ARGV.shift(2)

if not File.readable?(configFile) then
  puts "Can't load config file #{configFile}"
  exit(-1)
end

# Load the config
config = YAML::load_file(configFile)

# Make sure we have all needed config params
["server_url", "server_key", "s3_root"].each do |param|
  if not config.has_key?(param) then
    puts "Error: missing config param \"#{param}\""
    exit(-1)
  end
end

server_url = URI.parse(config["server_url"])
headers = { "Content-Type" => "application/json", "Authtoken" => config["server_key"] }
s3_root = config["s3_root"]

# validate s3_root before we go trying to mod anything
if not s3_root.end_with?("/") then
  s3_root << "/"
end

output = `s3cmd ls #{s3_root}`

if $? != 0 then
  puts "Error connecting to S3: #{output}"
  exit(-1)
end

case command.downcase
  when "addservice"
  
  if ARGV.length != 1 then
    puts "Usage: addService <service name>"
  else
    service = JSON.generate({"name" => ARGV[0]})

    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.request_post("/inventory/service/#{ARGV[0]}", service, headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Failed to add service: #{response.read_body} (#{response.message})"
        else
          puts "Added service #{ARGV[0]}"
        end
      end
    end
  end

  when "listconfigs" then
  
  if ARGV.length < 1 or ARGV.length > 2 then
    puts "Usage: listConfigs <service name> [detail|latest]"
  else
    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.request_get("/inventory/config/#{ARGV[0]}", headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Failed to get configs: #{response.read_body} (#{response.message})"
        else
          configs = JSON.parse(response.read_body).map {|s| ServiceEntry.from_json(s) }
          puts "Configs: "

          configs = configs.sort{|a,b| a.serial <=> b.serial }.reverse

          if ARGV[1] == "latest" and configs.length > 0 then configs = [configs[0]] end
                      
          configs.each do |config|
            tag_string = if config.tag != nil then
                           "(tag #{config.tag})"
                         else
                           ""
                         end

            puts "  #{config.name}-#{config.serial} #{tag_string} : stable=#{config.stable}, rejected=#{config.rejected}, deployed=#{config.deployed}, deploying=#{config.deploying}, failed=#{config.failed}"

            if ARGV.length == 2 then
              config.hooks.each do |k,v|
                sym = if v.symlink then " => #{v.symlink}" end
                puts "    #{k} = #{v.source}#{sym}"
              end

              puts "    Files:"
              config.files.sort{|a,b| a.source <=> b.source}.each do |file|
                sym = if file.symlink then " => #{file.symlink}" end
                puts "      #{file.source}#{sym}"
              end
              puts ""
            end
          end
        end
      end
    end
  end

  when "releaseconfig" then
  
  if ARGV.length != 2 then
    puts "Usage: releaseConfig <service> <config serial>"
  else
    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.request_post("/inventory/config/#{ARGV[0]}/#{ARGV[1]}", '{"stable" : true }', headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Failed to get configs: #{response.read_body} (#{response.message})"
        else
          puts "Released #{ARGV[0]}-#{ARGV[1]}"
        end
      end
    end
  end

  when "deleteconfig" then

  if ARGV.length != 2 then
    puts "Usage: deleteConfig <service> <config serial>"
  else
    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.delete("/inventory/config/#{ARGV[0]}/#{ARGV[1]}", headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Failed to delete config: #{response.read_body} (#{response.message})"
        else
          puts "Deleted #{ARGV[0]}-#{ARGV[1]}"
        end
      end
    end
  end
  
  when "addconfig"

  if ARGV.length < 1 then
    puts <<-EOH
Usage: addConfig <service name> <args>

Where <args> are one or more of:

tag=<tag name> - specify a tag for this config
stable=<stable value> specify true or false to mark the config as stable (defaults to true)

Hooks:
preinstall=<source file|remove>  
postinstall=<source file|remove> 
preremove=<source file|remove>   
postremove=<source file|remove>  

Setting a hook to a S3 URL sets the hook, setting to "remove" will remove the hook

Files:
<source file>[,<mode>]                  - Adds the file specified by the URL with optional mode
<symlink target>=<source file>[,<mode>] - Adds the file specified by the URL with optional mode and the given symlink target

Shortcuts for files:
default=<source file> - Adds the file symlinked to /etc/default/<service name>
init=<source file>    - Adds the file symlinked to /etc/init/<service name>.conf
conf=<source file>    - Adds the file symlinked to /etc/reportgrid/<service name>.conf
jar=<source file>     - Adds the file symlinked to /usr/share/java/<service name>.jar
EOH
  else
    # Verify that this is really a service
    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.request_get("/inventory/config/#{ARGV[0]}", headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Error adding config: #{ARGV[0]} is not a service"
          exit(-2)
        end
      end
    end

    service_name = ARGV.shift

    # Parse the arguments into proper JSON to send
    hooks = {}
    hooknames = {"preinstall" => true, "postinstall" => true, "preremove" => true, "postremove" => true}
    config = { "files" => [] }

    tag = nil

    # Expand any load params to their contents
    params = ARGV.map { |arg|
      if arg.start_with?("load=") then
        key, loadFile = ARGV[0].split('=')

        params = File.open(File.expand_path(loadFile)) do |input|
          input.lines.map{|l| l.strip}
        end
      else
        arg
      end
    }.flatten

    if params.length == 0 then
      puts "Parameters are required for adding a config"
    end
    
    params.each do |arg|
      key, value = arg.split('=')

      if value == nil and arg.index('=') then
        puts "Missing data after '=' in \"#{arg}\""
        exit(-2)
      end
      
      if not value then
        # this is a simple file
        source, mode = key.split(",")

        config["files"] << file_for(service_name,source, nil, mode, false, s3_root)
      else
        # Either a symlinked file, tag, or hook. 
        source, mode = value.split(",")

        if hooknames.has_key?(key) then
          hooks[key] = file_for(service_name, source, nil, mode, true, s3_root)
        elsif key == "tag"
          config["tag"] = value
        elsif key == "stable"
          config["stable"] = (value.downcase == "true")
        elsif key == "default"
          config["files"] << file_for(service_name, source, "/etc/default/#{service_name}", "644", true, s3_root)
        elsif key == "init"
          config["files"] << file_for(service_name, source, "/etc/init/#{service_name}.conf", "644", true, s3_root)
        elsif key == "conf"
          config["files"] << file_for(service_name, source, "/etc/reportgrid/#{service_name}.conf", "644", true, s3_root)
        elsif key == "jar"
          config["files"] << file_for(service_name, source, "/usr/share/java/#{service_name}.jar", "644", true, s3_root)
        else
          config["files"] << file_for(service_name, source, key, mode, true, s3_root)
        end
      end
    end

    # Always set to true unless otherwise requested
    if not config.has_key?("stable") then
      config["stable"] = true
    end

    # Upload files and transform results
    puts "Uploading files"
    hooks = hooks.map { |k,v| [k,upload(v)] }
    config["files"] = config["files"].map { |f| upload(f) }

    hooks.each do |key,value| config[key] = value end

    puts "\n\n#{ JSON.pretty_generate(config) }\n\n"

    service = JSON.generate(config)

    

    Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.request_post("/inventory/config/#{service_name}", service, headers) do |response|
        if not response.is_a? Net::HTTPOK then
          puts "Failed to add service: #{response.read_body} (#{response.message})"
        else
          puts "Added config for service #{service_name}"
        end
      end
    end
  end
  else
    puts "Unknown command #{command}"
end
