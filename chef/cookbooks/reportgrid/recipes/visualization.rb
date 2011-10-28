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
  docroot "/opt/reportgrid/visualization/src/main/js/staticrenderer"
  template "visualization.conf.erb"
end

#remote_directory "/opt/reportgrid/visualization" do
#  source "visualization"
#  files_owner "reportgrid"
#  files_mode  "0644"
#  owner "reportgrid"
#  mode "0755"
#  purge true
#end

# Pull from the "deploy" branch in Git for visualization
pathParts = node[:reportgrid][:visualization][:root].split('/')

bash "git_clone_visualization" do
  code <<-EOH 
cd #{pathParts[0..-2].join('/')} && \
/usr/bin/git clone git@rgviz.github.com:reportgrid/visualizations.git #{pathParts[-1]}  && \
cd #{pathParts[-1]} && \
git checkout #{node[:reportgrid][:visualization][:deploybranch]}
EOH
  not_if { File.directory?("#{node[:reportgrid][:visualization][:root]}/.git") }
end

bash "git_pull_visualization" do
  code <<-EOH
cd #{node[:reportgrid][:visualization][:root]} && \
git checkout #{node[:reportgrid][:visualization][:deploybranch]} && \
git fetch && \
git pull
EOH
  only_if { File.directory?("#{node[:reportgrid][:visualization][:root]}/.git") }
end

directory "#{node[:reportgrid][:visualization][:root]}/src/main/js/staticrenderer/cache" do
  owner "www-data"
  mode "755"
end

cron "purge_visualization_cache" do
  minute "55"
  # Purge items older than 30 days
  # TODO: parameterize this
  command "find #{node[:reportgrid][:visualization][:root]}/src/main/js/staticrenderer/cache -ctime +1 -delete > /dev/null"
end
