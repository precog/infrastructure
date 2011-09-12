#
# Cookbook Name:: reportgrid
# Recipe:: appserver
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"

user "reportgrid" do
  system true
  comment "ReportGrid service account"
  home "/var/log/reportgrid"
  shell "/bin/false"
  not_if "/usr/bin/id reportgrid" # FIXME: http://tickets.opscode.com/browse/CHEF-1701
end

directory "reportgrid_conf" do
  path "/etc/reportgrid"
  mode '755'
end

directory "reportgrid_data" do 
  path "/opt/reportgrid"
  mode '755'
end

directory "reportgrid_logs" do
  path "/var/log/reportgrid"
  owner 'reportgrid'
  group 'reportgrid'
  mode '755'
end

cookbook_file "/opt/reportgrid/GeoLiteCity.dat" do
  source "GeoLiteCity.dat"
  mode "0644"
end

[['analytics', 'v0', 30010], ['analytics', 'v1', 30020], ['jessup', 'v1', 30030]].each do |service,version,port|
  blueeyes_service "#{service}-#{version}" do
    port "#{port}"
  end
end
