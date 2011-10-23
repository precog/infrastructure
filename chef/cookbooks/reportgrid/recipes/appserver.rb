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

[['analytics', 'v0', 30010], ['analytics', 'v1', 30020], ['jessup', 'v1', 30030], ['billing', 'v1', 30040]].each do |service,version,port|
  blueeyes_service "#{service}-#{version}" do
    port "#{port}"
  end
end
