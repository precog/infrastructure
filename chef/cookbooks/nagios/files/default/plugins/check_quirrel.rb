#!/usr/bin/env ruby
#
# Copyright 2012, ReportGrid, Inc.
#
# ; -*-ruby-*-
#
#

require 'net/http'
require 'uri'

require 'rubygems'
require 'json'

if ARGV.length != 6 then
  puts "Called with #{ARGV.length} args: #{ARGV.join(',')}"
  puts "Usage: #{$0} <host> <port> <query name> <query content> <warn threshold in ms> <critical threshold in ms>"
  exit(3)
end

begin
  host, port, name, content, warn, critical = ARGV.shift(6)
  
  # Turn %27 back into single quote (single quotes can't be passed in) and replace + in the escaped string with %2B ("+" is space in url-escaped)
  # Same with semicolon (%3B)
  escaped = URI.escape(content.gsub('%27','\'').gsub('%3B',';')).gsub('+', '%2B')

  url = URI.parse("http://#{host}:#{port}/query?tokenId=C5EF0038-A2A2-47EB-88A4-AAFCE59EC22B&method=POST&callback=ReportGridJsonpCallback16517847&content=#{escaped}")
  #url = URI.parse("http://#{host}:#{port}/services/quirrel/v1/query?tokenId=C5EF0038-A2A2-47EB-88A4-AAFCE59EC22B&method=POST&callback=ReportGridJsonpCallback16517847&content=#{escaped}")
  
  Net::HTTP.start(url.host, url.port) do |http|
    requrl = url.request_uri
    start_time = Time.now
    http.request_get(requrl) do |response|
      duration = (Time.now - start_time) * 1000 # All times in ms
      if not response.is_a? Net::HTTPOK then
        $stderr.puts("UNKNOWN:Error collecting stats: #{response.read_body}")
      else
        begin
          message = "Response time for #{name} is #{duration}ms. Returned: \"#{response.body[0, 100]}...\""
          if duration > critical.to_f then
            puts "CRITICAL:#{message}"
            exit(2)
          elsif duration > warn.to_f then
            puts "WARNING:#{message}"
            exit(1)
          else 
            puts "OK:#{message}"
          end
        rescue => e
          $stderr.puts("UNKNOWN:Error parsing response: #{e.message}")
        end
      end
    end
  end
rescue => e
  $stderr.puts("UNKNOWN:Error processing poll: #{e.message}")
  exit(3)
end
