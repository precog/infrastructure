#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.
#
# ; -*-ruby-*-
#
#

require 'net/http'
require 'uri'

require 'rubygems'
require 'json'

if ARGV.length != 5 then
  puts "Usage: #{$0} <host> <request path> <errors|response> <warn threshold> <critical threshold>"
  exit(3)
end

# Utility method for fetching nested hash values safely
def safe_get (d, *keys)
  begin
    s = d
    keys.each {|k| s = s[k]}
    yield s
  rescue NoMethodError => e
  end
end

begin
  host, path, command, warn, critical = ARGV.shift(6)
  
  url = URI.parse("http://#{host}/")
  
  Net::HTTP.start(url.host, url.port) do |http|
    http.request_get(path) do |response|
      if not response.is_a? Net::HTTPOK then
        $stderr.put("Unknown:Error collecting stats: #{response.read_body}")
      else
        begin
          data = JSON.parse(response.read_body)
        
          case command
          when "errors"
            error_value = nil

            result = ["GET", "POST"].map do |verb|
              safe_get(data,"requests",verb,"errors","errorDistribution") {|errors|
                error_value = errors.map{|k,v| v["5min x 1"].to_i }.flatten.reduce(:+)
              }
              error_value ||= 0
              error_value
            end.reduce(:+)

            if result > critical.to_i then
              puts "Critical:Total of #{error_value} errors on service"
            elsif result > warn.to_i then
              puts "Warning:Total of #{error_value} errors on service"
            else
              puts "OK:Total of #{error_value} errors on service"
            end
          when "response"
            times = ["GET", "POST"].map do |verb|
              safe_get(data,"requests",verb,"timing","averageTime","5min x 1") {|v| [verb,v[0].to_f] }
            end

            max = times.sort{|a,b| a[1] <=> b[1]}[-1]

            if max[1] > critical.to_f then
              puts "Critical:#{max[0]} response average is #{max[1]}"
            elsif max[1] > warn.to_f then
              puts "Warning:#{max[0]} response average is #{max[1]}"
            else
              puts "OK:#{max[0]} response average is #{max[1]}"
            end
          end
        rescue => e
          $stderr.puts("Unknown:Error parsing response: #{e.message}")
        end
      end
    end
  end
rescue => e
  $stderr.puts("Unknown:Error processing poll: #{e.message}")
  exit(3)
end
