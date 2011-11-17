#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.
#

require 'logger'

require 'rubygems'
require 'json'

require 'rg-service'

class DeployerService
  attr_reader :headers

  def initialize(url,key,log)
    @server_url = url
    @server_key = key
    @log = log

    @headers = { "Content-Type" => "application/json", "Authtoken" => key }
  end

  def do_get(path)
    Net::HTTP.start(@server_url.host, @server_url.port) do |http|
      http.request_get(path, @headers) do |response|
        yield response
      end
    end
  end

  def do_post(path,data)
    Net::HTTP.start(@server_url.host, @server_url.port) do |http|
      http.request_post(path, data, @headers) do |response|
        yield response
      end
    end
  end

  def hosts
    do_get("/inventory/host/") do |response|
      if not response.is_a? Net::HTTPOK then
        raise "Failed to get hosts: #{response.read_body} (#{response.message})"
      else
        return JSON.parse(response.read_body)
      end
    end
  end

  def configs(name)
    do_get("/inventory/config/#{name}") do |response|
      if not response.is_a? Net::HTTPOK then
        raise "Failed to get configs: #{response.read_body} (#{response.message})"
      else
        return JSON.parse(response.read_body).map {|s| ServiceEntry.from_json(s) }
      end
    end
  end

  def add_service(name)
    service = JSON.generate({"name" => name})

    do_post("/inventory/service/#{name}", service) do |response|
      if not response.is_a? Net::HTTPOK then
        puts "Failed to add service: #{response.read_body} (#{response.message})"
      else
        puts "Added service #{ARGV[0]}"
      end
    end
  end

  def delete_config(service,serial)
    Net::HTTP.start(@server_url.host, @server_url.port) do |http|
      http.delete("/inventory/config/#{service}/#{serial}") do |response|
        if not response.is_a? Net:HTTPOK then
          raise "Error deleting config: #{response.read_body}"
        end
      end
    end
  end

end
