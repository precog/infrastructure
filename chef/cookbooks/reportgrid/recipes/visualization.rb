#
# Cookbook Name:: reportgrid
# Recipe:: visualization
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"
include_recipe "reportgrid::source"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "phantomjs"

# Grab wkhtmltopdf from S3
execute "pull-wkhtmltopdf" do
  command "s3cmd sync --no-progress --no-delete-removed s3://ops.reportgrid.com/bin/wkhtmltopdf-amd64 /usr/local/bin/"
end

directory "visualization_root" do
  path node[:reportgrid][:visualization][:root]
  recursive true
  owner "reportgrid"
  group "reportgrid"
  mode "755"
end

cachedir = "#{node[:reportgrid][:visualization][:root]}/staticrenderer/cache" 
tmpdir = "#{node[:reportgrid][:visualization][:root]}/tmp" 

directory cachedir do
  recursive true
  owner "www-data"
  mode "755"
end

directory tmpdir do
  recursive true
  owner "www-data"
  mode "755"
end

cron "purge_visualization_cache" do
  minute "55"
  # Purge items older than 30 days
  # TODO: parameterize this
  command "find #{cachedir} -ctime +1 -delete > /dev/null"
end

# Pull from s3
cron "pull_s3_vis" do
  command "s3cmd -c /root/.s3cfg --no-delete-removed --no-progress sync #{node[:reportgrid][:visualization][:s3url]} #{node[:reportgrid][:visualization][:root]}/ > /dev/null"
end

web_app "visualization" do
#  server_name "api.reportgrid.com"
#  server_aliases [node['fqdn']]
  server_name node['fqdn']
  server_aliases []
  docroot "#{node[:reportgrid][:visualization][:root]}/staticrenderer"
  template "visualization.conf.erb"
end

