#
# Cookbook Name:: reportgrid
# Recipe:: visualization
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "phantomjs"

directory "visualization_root" do
  path "/opt/reportgrid/visualization"
  recursive true
  owner "reportgrid"
  group "reportgrid"
  mode "755"
end

web_app "visualization" do
#  server_name "api.reportgrid.com"
#  server_aliases [node['fqdn']]
  server_name node['fqdn']
  server_aliases []
  docroot "/opt/reportgrid/visualization"
  template "visualization.conf.erb"
end

remote_directory "/opt/reportgrid/visualization" do
  source "visualization"
  files_owner "reportgrid"
  files_mode  "0644"
  owner "reportgrid"
  mode "0755"
  purge true
end

cron "purge_visualization_cache" do
  minute "55"
  # Purge items older than 30 days
  # TODO: parameterize this
  command "find /opt/reportgrid/visualization/cache -ctime +30 -delete > /dev/null"
end
