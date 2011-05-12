#
# Cookbook Name:: reportgrid
# Recipe:: website
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "nginx"
include_recipe "s3tools"
include_recipe "reportgrid::source"

#template "reportgrid" do
#  source "reportgrid.nginx.erb"
#  path "/etc/nginx/sites-available/reportgrid"
#  mode "0644"
#  notifies :restart, resources(:service => "nginx")
#end

#link "reportgrid" do
#  to "/etc/nginx/sites-available/reportgrid"
#  target_file "/etc/nginx/sites-enabled/reportgrid"
#  notifies :restart, resources(:service => "nginx")
#end

execute "git_clone_website" do
  command "cd #{node[:reportgrid][:source][:root]} && /usr/bin/git clone git@github.com:reportgrid/website.git"
  not_if { File.directory?("#{node[:reportgrid][:source][:root]}/website") }
end

cron "git_pull_website" do
  command "cd #{node[:reportgrid][:source][:root]}/website && /usr/bin/git pull >> /dev/null 2>&1 && /usr/bin/s3cmd -v --exclude='.git/*' --acl-public --add-header='Cache-Control:max-age=0' sync ./ s3://www.reportgrid.com/ >> /dev/null 2>&1"
  minute "*"
  only_if { File.directory?(node[:reportgrid][:source][:root]) }
end
