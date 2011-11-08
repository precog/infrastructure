#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.
#

require 'rubygems'

require 'fileutils'
require 'json'
require 'logger'
require 'tempfile'


require 'rg-service'
require 'rg-util'

# Exception to indicate a transient error with downloading
class DownloadFailure < RuntimeError
  attr_reader :source

  def initialize(source)
    @source = source
  end
end

class Deployer
  attr_reader :basedir

  def initialize(basedir, s3cfg, log)
    if not File.readable?(s3cfg) then
      raise "Cannot deploy: missing s3cmd configuration"
    end

    # Test for existence of s3cmd
    `s3cmd --help`

    if $? != 0 then
      raise "Cannot deploy: missing s3cmd"
    end

    @s3cmdline = "s3cmd --config #{s3cfg} --no-progress"

    @basedir = basedir
    @s3cfg = s3cfg
    @log = log
  end

  def upgrade(service)
    # Collect any error messages for final return
    messages = []

    # If we have an existing config, we need to save it in case
    # we need to roll back
    config_file = File.expand_path(service.name + ".conf", @basedir)
    rollback_file = config_file + ".rollback"

    if File.file?(config_file) then
      FileUtils.mv(config_file, rollback_file)
    end

    # Make sure we have a directory for artifacts
    target_dir = File.expand_path(service.name, @basedir)
    if not File.directory?(target_dir) then
      Dir.mkdir(target_dir)
    end

    # For an upgrade, we simply run deploy (for now)
    # For our initial scenarios we don't need to remove the
    # prior version
    begin
      deploy(service)

      # deploy succeeded, so we can save our new service data
      output = File.open(config_file, "w")
      output.write(JSON.pretty_generate(service.to_hash))
      output.close

      # Deploy succeeded
      return [true, ["deploy succeeded"]]
    rescue => e
      # Something failed, so we need to deal with it and notify someone
      messages << "  Rolling back failed deployment of #{service.name}-#{service.serial}: #{e.message}"

      begin
        # Load the rollback file (if it exists) and use it for deploy
        if File.file?(rollback_file) then
          old_service = ServiceEntry.from_file(rollback_file)
          deploy(old_service)
          FileUtils.mv(rollback_file, config_file)

          messages << "  Rollback succeeded for #{service.name}-#{old_service.serial}"
        else
          messages << "  No rollback config for #{service.name}"
        end
      rescue => e
        # A failure on rollback
        messages << "  !!! Rollback failed for #{service.name}: #{e.message}"
      end
    end

    return [false, messages]
  end

  def remove(service)
    run_hook("remove", service, "preremove")
    service.files.each do |f| 
      # For now we only remove symlinks, leaving the files intact
      if f.symlink and File.symlink?(f.symlink) then
        File.delete(f.symlink)
      end
    end
    run_hook("remove", service, "postremove")
  end   

  def deploy(service)
    run_hook("deploy", service, "preinstall")  
    service.files.each { |f| get_file(service.name, f) }
    run_hook("deploy", service, "postinstall")
  end

  def run_hook(action, service, hookname)
    if service.hooks[hookname] then
      @log.info("Running #{service.name}-#{service.serial} #{hookname}")
      target = get_file(service.name, service.hooks[hookname])
      
      output = `#{target}`.strip
      
      @log.debug("#{hookname} output: #{output}")

      if $? != 0 then
        @log.error("#{hookname} failed!")
        raise "#{action} failed on #{service.name} #{hookname} : #{output}"
      else
        @log.info("Completed #{service.name}-#{service.serial} #{hookname}")
      end
    end
  end

  def get_file(service_name, entry)
    @log.debug("Pulling #{entry.source}")
    target_dir = File.expand_path(service_name, @basedir)
    target = File.expand_path(entry.filename, target_dir)

    # We'll keep track of any temp file downloads so we can move them into place
    # once all of the downloads have succeeded
    tempDownloads = []

    if File.file?(target) then
      @log.debug("Target #{target} exists. Checking hash")

      if not Util.valid_hash(target, entry.source, @s3cfg, @log) then      
        @log.debug("Invalid hash. Downloading to temp file")
        # TODO: check MD5 sums?
        # Download to a temp file before replacing to make sure we got it
        tempfile = Tempfile.new(entry.filename)
        tempname = tempfile.path
        tempfile.close!

        result = `#{@s3cmdline} get #{entry.source} #{tempname} 2>&1`

        if $? != 0 then
          raise DownloadFailure.new(entry.source), result
        end

        tempDownloads << [tempname,target]
      else
        @log.debug("Hash matches, skipping")
      end
    else
      # No existing file, just s3cmd into place
      result = `#{@s3cmdline} get #{entry.source} #{target} 2>&1`

      if $? != 0 then
        raise DownloadFailure.new(entry.source), result
      end
    end

    # Move downloaded temp files
    tempDownloads.each do |tempname,target|
      FileUtils.mv(tempname, target)
    end
    
    # Check mode and symlinks
    desired_mode = (entry.mode or "0755")

    @log.debug("Desired file mode = #{desired_mode}")

    if Util.file_mode(target) != desired_mode then
      File.chmod(desired_mode.oct, target)
    end

    if entry.symlink then
      @log.debug("Adding symlink #{entry.symlink}")
      # Remove any existing symlink target (safe???)
      if File.exists?(entry.symlink) or File.symlink?(entry.symlink) then
        @log.debug("Removing existing target #{entry.symlink}")
        File.delete(entry.symlink)
      end

      File.symlink(target, entry.symlink)
    end

    return target
  end
end
    

if __FILE__ == $0 then
  if ARGV.length != 1 then
    puts "Usage: #{$0} <base dir>"
    exit(-1)
  end

  deployer = Deployer.new(ARGV[0], Logger.new(STDOUT))

  Dir.chdir(ARGV[0])

  Dir.glob('*.conf').each { |conf|
    puts "Deploying #{conf}"
    deployer.deploy(ServiceEntry.from_file(conf))
  }
end
