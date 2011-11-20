#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.

require 'net/http'
require 'uri'
require 'yaml'
require 'logger'

require 'rubygems'
require 'json'

# Local includes
$:.push(File.expand_path(File.dirname(__FILE__)) + "/lib")
require 'rg-service'
require 'rg-util'
require 'rg-web'

load "#{File.expand_path(File.dirname(__FILE__))}/helpers.rb"

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
s3_root = config["s3_root"]
log = Logger.new(STDOUT)
log.level = Logger::INFO

service = DeployerService.new(server_url, config["server_key"], log)
uploader = Uploader.new("~/.s3cfg", log)

# validate s3_root before we go trying to mod anything
if not s3_root.end_with?("/") then
  s3_root << "/"
end

output = `s3cmd ls #{s3_root}`

if $? != 0 then
  puts "Error connecting to S3: #{output}"
  exit(-1)
end

begin
  case command.downcase
  when "addservice"
    
    if ARGV.length != 1 then
      puts "Usage: addService <service name>"
    else
      service.add_service(ARGV[0])
    end

  when "listconfigs" then
    
    if ARGV.length < 1 or ARGV.length > 2 then
      puts "Usage: listConfigs <service name> [detail|latest]"
    else
      # Fetch the list of hosts, too, so that we can report on current status
      hosts = service.hosts().map{ |entry|
        [entry["hostname"], Hash[*entry["currentVersions"].map{|v| [v["name"],v["serial"]]}.flatten]]
      }

      configs = service.configs(ARGV[0]).sort{|a,b| a.serial <=> b.serial }.reverse
      puts "Configs: "

      if ARGV[1] == "latest" and configs.length > 0 then configs = [configs.select{|c| c.rejected == false }[0]] end
      
      configs.each do |config|
        tag_string = if config.tag != nil then
                       "(tag #{config.tag})"
                     else
                       ""
                     end

        puts "  #{config.name}-#{config.serial} #{tag_string} : stable=#{config.stable}, rejected=#{config.rejected}, deployed=#{config.deployed.size}, deploying=#{config.deploying.size}, failed=#{config.failed.size}"
        
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
          
          if config.deployed.size > 0 then
            puts "    Successfully deployed on:"
            config.deployed.sort{|a,b| a <=> b}.each {|d| puts "      #{d}" }
          end

          if config.deploying.size > 0 then
            puts "    Currently deploying on:"
            config.deploying.sort{|a,b| a <=> b}.each {|d| puts "      #{d}" }
          end

          if config.failed.size > 0 then
            puts "    Deployment failed on:"
            config.failed.sort{|a,b| a <=> b}.each {|d| puts "      #{d}" }
          end

          running_hosts = hosts.map{ |hostname,current|
            if current[ARGV[0]] == config.serial then
              [hostname]
            else
              []
            end
          }.flatten
          
          if running_hosts.length > 0 then
            puts "    Currently running on:"
            puts running_hosts.sort{|a,b| a <=> b}.map{|h| "      #{h}\n" }
          end

          puts ""
        end
      end
    end

  when "rejectconfig" then
    
    if ARGV.length != 2 then
      puts "Usage: rejectconfig <service> <config serial>"
    else
      Net::HTTP.start(server_url.host, server_url.port) do |http|
        http.request_post("/inventory/config/#{ARGV[0]}/#{ARGV[1]}", '{"rejected" : true }', service.headers) do |response|
          if not response.is_a? Net::HTTPOK then
            puts "Failed to get configs: #{response.read_body} (#{response.message})"
          else
            puts "Rejected #{ARGV[0]}-#{ARGV[1]}"
          end
        end
      end
    end

  when "deleteconfig" then

    if ARGV.length != 2 then
      puts "Usage: deleteConfig <service> <config serial>"
    else
      Net::HTTP.start(server_url.host, server_url.port) do |http|
        http.delete("/inventory/config/#{ARGV[0]}/#{ARGV[1]}", service.headers) do |response|
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
      log.info("Checking service")
      Net::HTTP.start(server_url.host, server_url.port) do |http|
        http.request_get("/inventory/config/#{ARGV[0]}", service.headers) do |response|
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
        exit
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

          config["files"] << uploader.file_for(service_name,source, nil, mode, false, s3_root)
        else
          # Either a symlinked file, tag, or hook. 
          source, mode = value.split(",")

          if hooknames.has_key?(key) then
            hooks[key] = uploader.file_for(service_name, source, nil, mode, true, s3_root)
          elsif key == "tag"
            config["tag"] = value
          elsif key == "stable"
            config["stable"] = (value.downcase == "true")
          elsif key == "default"
            config["files"] << uploader.file_for(service_name, source, "/etc/default/#{service_name}", "644", true, s3_root)
          elsif key == "init"
            config["files"] << uploader.file_for(service_name, source, "/etc/init/#{service_name}.conf", "644", true, s3_root)
          elsif key == "conf"
            config["files"] << uploader.file_for(service_name, source, "/etc/reportgrid/#{service_name}.conf", "644", true, s3_root)
          elsif key == "jar"
            config["files"] << uploader.file_for(service_name, source, "/usr/share/java/#{service_name}.jar", "644", true, s3_root)
          else
            config["files"] << uploader.file_for(service_name, source, key, mode, true, s3_root)
          end
        end
      end

      # Always set to true unless otherwise requested
      if not config.has_key?("stable") then
        config["stable"] = true
      end

      # Compare our new config to the latest config
      current = service.configs(service_name).sort{|a,b| a.serial <=> b.serial }.reverse[0]

      if current != nil then
        newHooks = ["preinstall", "postinstall", "preremove", "postremove"].map { |hook|
          if hooks[hook] == nil then
            # We're not modifying the existing hook, so this is fine
            []
          else
            if current.hooks[hook] == nil then
              # We have a hook and the current config doesn't, so we're new
              [hook, hooks[hook]]
            else
              # Compare hook files based on hash only for now (symlinks really aren't used in hooks)
              if Util.valid_hash(hooks[hook]["source"], current.hooks[hook].source, "~/.s3cfg", log) then
                log.info("The new #{hook} hook matches the current hook script")
                []
              else
                [{ hook => hooks[hook] }]
              end
            end
          end
        }.flatten

        newFiles = config["files"].map {|file|
          # We prefer matching a file based on symlink rather than URL
          currentFile = if file["symlink"] != nil then
                          current.files.find{|f| file["symlink"] == f.symlink}
                        else
                          current.files.find{|f| file["url"] == f.source }
                        end

          if currentFile == nil
            # Couldn't locate a matching file, so this must be new
            [file]
          else
            # We either matched on symlink or url, so just make sure that we have the same file
            if Util.valid_hash(file["source"],currentFile.source,"~/.s3cfg", log) and file["mode"] == currentFile.mode then
              log.info("#{file["source"]} matches existing #{currentFile.source}")
              []
            else
              [file]
            end
          end
        }.flatten
      end

      # Convert newHooks into a map
      newHooks = Hash[*newHooks]

      hooksMatch = newHooks.length == 0
      filesMatch = newFiles.length == 0

      if hooksMatch and filesMatch then
        log.info("Skipping new configuration identical to current configuration")
        exit
      end

      # Upload files and transform results
      log.info("Uploading hooks")
      if not hooksMatch then
        hooks = newHooks.map { |k,v| [k,uploader.upload(v)] }
        # Place the updated hooks into the config object
        hooks.each do |key,value| config[key] = value end
      end

      log.info("Uploading files")
      config["files"] = newFiles.map { |f| uploader.upload(f) }

      puts "\n\n#{ JSON.pretty_generate(config) }\n\n"

      serviceObj = JSON.generate(config)

      Net::HTTP.start(server_url.host, server_url.port) do |http|
        http.request_post("/inventory/config/#{service_name}", serviceObj, service.headers) do |response|
          if not response.is_a? Net::HTTPOK then
            puts "Failed to add service: #{response.read_body} (#{response.message})"
          else
            result = JSON.parse(response.read_body)
            puts "Added config for service #{service_name}\nserial=#{result["serial"]}"
          end
        end
      end
    end

  when "deleteconfig"
    if ARGV.length != 2 then
      puts "Usage: deletconfig <service> <serial>"
      exit(2)
    end

    service.delete_config(ARGV[0], ARGV[1])
  else
    puts "Unknown command #{command}"
  end
rescue => e
  puts e.message
end
