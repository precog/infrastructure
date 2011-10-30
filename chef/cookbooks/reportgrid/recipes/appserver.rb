#
# Cookbook Name:: reportgrid
# Recipe:: appserver
#
# Copyright 2010-2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "reportgrid::baseenv"

cookbook_file "/opt/reportgrid/GeoLiteCity.dat" do
  source "GeoLiteCity.dat"
  mode "0644"
end

[['analytics', 'v0', 30010], ['jessup', 'v1', 30030]].each do |service,version,port|
  blueeyes_service "#{service}-#{version}" do
    port "#{port}"
  end
end

blueeyes_service "analytics-v1" do
  port "30020"
  jar_file "analytics-assembly-1.2.4.jar"
end
