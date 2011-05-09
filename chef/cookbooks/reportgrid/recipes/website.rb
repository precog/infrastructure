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

# FIXME: rexclude used as a workaround for exclude option not excluding the dot files in the root
cron "svn_update_website" do
  command "cd #{node[:reportgrid][:source][:root]}/reportgrid && /usr/bin/svn update >> /dev/null 2>&1 && /usr/bin/s3cmd -v --acl-public --exclude='/.*' --rexclude='\\.(svn|project)' --add-header='Cache-Control:max-age=0' sync ./ s3://www.reportgrid.com/ >> /dev/null 2>&1"
  minute "*"
  only_if { File.directory?(node[:reportgrid][:source][:root]) }
end
