#
# Cookbook Name:: rgdeployer
# Recipe:: default
#
# Copyright 2011, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ruby"
include_recipe "postfix"
include_recipe "reportgrid::baseenv"

#gem_package "mail" do
#  action :install
#end

# Use this hack because the gem_package above doesn't work for some reason...
execute "gem list --local | grep mail > /dev/null || gem install mail"

directory "/opt/reportgrid/deployer" do
  owner "reportgrid"
  mode "755"
end

remote_directory "/opt/reportgrid/deployer/agent/lib" do
  source "deployer/lib"
  files_owner "reportgrid"
  owner "reportgrid"
  mode "755"
  purge true
  notifies :restart, "service[deployer]"
end

cookbook_file "/opt/reportgrid/deployer/agent/s7agent.rb" do
  source "deployer/s7agent.rb"
  mode "755"
  notifies :restart, "service[deployer]"
end

directory "/opt/reportgrid/deployer/base" do
  owner "reportgrid"
  mode "755"
end

directory "/var/log/reportgrid/deployer" do
  owner "reportgrid"
  mode "755"
end

cookbook_file "/etc/init/deployer.conf" do
  source "deployer.init.conf"
  notifies :restart, "service[deployer]"
end

template "/etc/reportgrid/deployer.conf" do
  source "deployer.conf.erb"
  owner "reportgrid"
  mode "600"
  notifies :restart, "service[deployer]"
end

service "deployer" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
  supports :restart => false
end

template "/etc/logrotate.d/deployer" do
  source "logrotate.conf.erb"
  mode "644"
end
