#!/usr/bin/env ruby

require 'logger'
require 'yaml'
require 'net/http'
require 'uri'

require 'rubygems'
require 'json'
require 'mail'

# Local includes
$:.push(File.expand_path(File.dirname(__FILE__)) + "/lib")

require 'rg-inventory'
require 'rg-deploy'

if ARGV.length != 1 then
  puts "Usage: #{$0} <config file>"
  exit(-1)
end

config = YAML::load_file(ARGV[0])

# Set up logging
log = Logger.new((config['logfile'] or STDOUT))

if config['debug'] then
  log.level = Logger::DEBUG
else
  log.level = Logger::INFO
end

# Load config params
basedir = config['basedir']
notified = (config['notified'] or "operations@reportgrid.com")
server_url = config['server_url']
server_key = config['server_key']
only_stable = if config.has_key?('only_stable') then config['only_stable'] else true end
interval = (config['interval'] or 60)
s3cfg = config['s3cfg']

log.info("Starting agent running against #{server_url}. Only stable releases = #{only_stable}")

# Validate config params
if ! (File.directory?(basedir) and File.readable?(basedir) and File.writable?(basedir)) then
  log.error("Invalid based directory: #{basedir}")
  exit(-3)
end

if not server_url or not server_key then
  log.error("Missing server parameters")
  exit(-3)
end

if not s3cfg then
  log.error("Missing s3cmd configuration (s3cfg parameter)")
  exit(-3)
end

if not File.readable?(s3cfg) then
  log.error("Can't load s3cmd configuration from #{s3cfg}")
  exit(-3)
end

server_url = URI.parse(server_url)

hostname = (config['hostname'] or `hostname -f`.strip)

begin
  inventory = Inventory.new(basedir, s3cfg, log)
  deployer = Deployer.new(basedir, s3cfg, log)
rescue => e
  puts e.message
  exit(-3)
end

headers = { "Content-Type" => "application/json", "Authtoken" => server_key }
  
# Mail setup to disable TLS
Mail.defaults do
  delivery_method :smtp, { :address              => "localhost",
                           :port                 => 25,
                           :domain               => 'localhost.localdomain',
                           :user_name            => nil,
                           :password             => nil,
                           :authentication       => nil,
                           :enable_starttls_auto => false  }
end

# To avoid chef immediately restarting us from having an impact
log.info("Pausing for one minute on startup")
sleep 60

while (true)
  begin
    log.info("Performing inventory scan")
    inventory.scan

    # Send our inventory and process the returned upgrades
    Net::HTTP.start(server_url.host, server_url.port) do |http|
      service_json = JSON.generate({ "onlyStable" => only_stable, "current" => inventory.services.values.map {|s| s.to_hash }})
      log.debug("Posting inventory: #{service_json}")
      http.request_post("/inventory/host/#{hostname}", service_json, headers) do |response| 
        if not response.is_a? Net::HTTPOK then
          log.error("Received error on config post: #{response.body}")
        else
          needs_upgrade = JSON.parse(response.body).map {|s| ServiceEntry.from_json(s) }

          if needs_upgrade.length > 0 then
            log.info("Upgrading services: #{needs_upgrade.map{|s| s.name }.join(", ")}")

            needs_upgrade.each do |service|
              begin
                log.info("Upgrading #{service.name}")
                upgrade_succeeded, messages = deployer.upgrade(service)

                if upgrade_succeeded then
                  log.info("Upgraded succeeded on #{service}")
                  http.post("/inventory/deploy/success/#{service.name}/#{service.serial}", "\"#{hostname}\"", headers)
                else
                  formatted_message = messages.join("\n")
                  log.error("Upgrade failed on #{service}:\n#{formatted_message}")
                  http.post("/inventory/deploy/failure/#{service.name}/#{service.serial}", "\"#{hostname}\"", headers)
                  
                  begin
                    Mail.deliver do
                      from 'operations@reportgrid.com'
                      to notified
                      subject "Upgrade failed on #{service}"
                      body formatted_message
                    end
                  rescue => e
                    log.error("Error sending email on failure: #{e.message}")
                  end
                end
              rescue DownloadFailure => e
                log.error("Download failure for #{service.name} source #{e.source}: #{e.message}")
              end
            end
          else
            log.info("Up-to-date!")
          end
        end
      end
    end
  rescue => e
    log.error("Error during poll: #{e.message}")
  end

  log.info("Poll complete")
  
  sleep(interval)
end

  
