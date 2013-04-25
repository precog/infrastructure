#!/usr/bin/env ruby
#
# Copyright 2012, ReportGrid, Inc.
#
# ; -*-ruby-*-
#
#

TEST_TOKEN="1BF2FA96-8817-4C98-8BCB-BEC6E86CB3C2"

require 'net/http'
require 'uri'

require 'rubygems'
require 'json'

if ARGV.length != 7 then
  puts "Called with #{ARGV.length} args: #{ARGV.join(',')}"
  puts "Usage: #{$0} <host> <port> <token> <query name> <query content> <warn threshold in ms> <critical threshold in ms>"
  exit(3)
end

begin
  host, port, token, name, content, warn, critical = ARGV.shift(7)
  
  # Turn %27 back into single quote (single quotes can't be passed in) and replace + in the escaped string with %2B ("+" is space in url-escaped)
  # Same with semicolon (%3B)
  escaped = URI.escape(content.gsub('%27','\'').gsub('%3B',';')).gsub('+', '%2B').gsub('&', '%26')
  #escaped = URI.escape(content).gsub('+', '%2B')

  url = URI.parse("http://#{host}:#{port}/analytics/v2/analytics/fs/?apiKey=#{token}&method=GET&callback=ReportGridJsonpCallback16517847&q=#{escaped}")

  start_time = Time.now
 # puts "URL= #{url}"
  
  Net::HTTP.start(url.host, url.port) do |http|
    requrl = url.request_uri
    http.request_get(requrl) do |response|
      if not response.is_a? Net::HTTPOK then
        puts("UNKNOWN:Error collecting stats: #{response.read_body}")
        exit(3)
      else
        $stderr.puts(response.read_body)
        begin
          duration = (Time.now - start_time) * 1000 # All times in ms
          message = "Results in #{duration}ms|duration=#{duration}ms"
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
          puts("UNKNOWN:Error parsing response: #{e.message}")
          exit(3)
        end
      end
    end
  end
rescue => e
  puts("UNKNOWN:Error processing poll: #{e.message}")
  exit(3)
end
