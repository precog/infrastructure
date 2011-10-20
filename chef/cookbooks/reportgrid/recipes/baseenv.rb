#
# Cookbook Name:: reportgrid
# Recipe:: baseenv
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
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
