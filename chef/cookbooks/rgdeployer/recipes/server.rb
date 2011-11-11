#
# Cookbook Name:: rgdeployer
# Recipe:: default
#
# Copyright 2011, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "reportgrid::baseenv"

jar_file = "sector7-assembly-0.1.1.jar"

directory "/opt/reportgrid/deployservice" do
  owner "reportgrid"
  mode "755"
end

template "/etc/reportgrid/deployer-v1.conf" do
  owner "reportgrid"
  mode "600"
  notifies :restart, "service[deployer-v1]"
end

cookbook_file "/opt/reportgrid/deployservice/#{jar_file}" do
  owner "reportgrid"
  mode "644"
  notifies :restart, "service[deployer-v1]"
end

execute "init-reload" do
  action :nothing
  command "initctl reload-configuration"
end

template "/etc/init/deployer-v1.conf" do
  variables(
    :jar_file => jar_file
  )
  source "deployer-v1.init.erb"
  notifies :run, "execute[init-reload]"
end

service "deployer-v1" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

template "/etc/logrotate.d/deployer-v1" do
  source "logrotate.server.conf.erb"
  mode "644"
end
