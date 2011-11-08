#! /usr/bin/env ruby 
# Copyright 2011, ReportGrid, Inc.
#

require 'rubygems'
require 'json'
require 'logger'

# Local libs
require 'rg-service'
require 'rg-util'

class Inventory
  attr_reader :basedir, :services

  def initialize (basedir, s3cfg, log)
    @basedir = basedir
    @log = log
    @s3cfg = s3cfg
  end

  def scan
    services = {}
    Dir.chdir(@basedir)
    Dir.glob("*.conf").each do |config|
      begin
        entry = ServiceEntry.from_file(config)

        valid, errors = valid_config?(entry)

        if valid then
          services[entry.name] = entry
        else
          @log.warn("#{config} has the following errors:\n" + errors.map { |e| "  " + e }.join("\n"))
        end
      rescue => e
        @log.warn("Could not load #{config}: #{e.message}")
        @log.debug("#{e.backtrace.join("\n")}")
      end
    end

    @services = services

    list = services.map {|s,v| "(#{s}, #{v.serial})" }

    @log.info("Found #{services.size} service#{ if list.size != 1 then 's' else '' end} : #{list.join(', ')}")
  end

  def valid_file_entry?(service_name, file_entry)
    target_dir = File.expand_path(service_name, @basedir)

    @log.debug("Target dir = #{target_dir}")

    target_file = File.expand_path(file_entry.filename, target_dir)

    @log.debug("Source file = #{target_file} (#{file_entry.filename})")

    if not File.file?(target_file) then
      return [false, "source #{target_file} does not exist"]
    else
      if not Util.valid_hash(target_file, file_entry.source, @s3cfg, @log) then
        return [false, "hash mismatch on #{target_file}"]
      end
    end

    if file_entry.symlink then
      if not File.exists?(file_entry.symlink) then
        return [false, "symlink #{file_entry.symlink} doesn't exist"]
      end

      if not File.symlink?(file_entry.symlink) then
        return [false, "#{file_entry.symlink} is a real file, not a symlink"]
      end

      if File.readlink(file_entry.symlink) != target_file then
        return [false, "symlink points to wrong file: #{File.readlink(file_entry.symlink)}"]
      end
    end

    mode = Util.file_mode(target_file)

    desired_mode = (file_entry.mode or "0755")

    if mode != desired_mode then
      return [false, "file mode differs: #{mode} != #{desired_mode}"]
    end

    [true, "valid file"]
  end

  #
  # A valid service is JSON of the following grammar (optional fields marked with a ?):
  #
  # FILE := { "source" : <s3 source URL>, "symlink?" : <file symlink destination>, "mode?" : <octal mode string, defaults to 755> }
  #
  # SERVICE := { "name" : <service name>,
  #              "preinstall?" : FILE,
  #              "postinstall?" : FILE,
  #              "preremove?" : FILE,
  #              "postremove?" : FILE,
  #              "files" : [ FILE, FILE, ... ] }
  #
  def valid_config?(entry)
    scripts = ["preinstall", "postinstall", "preremove", "postremove"].map { |s| [s, entry.hooks[s]] }.select { |v| v[1] != nil }

    files = entry.files.map { |f| ["file #{f.source}", f] }

    errors = (scripts + files).map { |name,file| [name, valid_file_entry?(entry.name, file)]}.select { |name,result| !result[0] }.map { |name,result| "#{name}: #{result[1]}" }

    if errors != [] then
      return [false, errors]
    else
      return [true, "no errors"]
    end
  end
end
      
if __FILE__ == $0
  if ARGV.length != 1 then
    puts "Usage: #{$0} <basedir>"
    exit(-1)
  end

  i = Inventory.new(ARGV[0], Logger.new(STDOUT))

  i.scan

#  i.services.each { |s,v|
#    puts "Service #{s} = #{JSON.pretty_generate(v.to_hash)}"
#  }

  puts JSON.pretty_generate(i.services.values.map {|s| s.to_hash})
end
    
      
    
        
