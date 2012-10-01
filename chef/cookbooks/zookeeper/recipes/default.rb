#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "precog::baseenv"

package "zookeeper"

execute "init-reload" do
  action :nothing
  command "initctl reload-configuration"
end

template "zookeeper.init" do
  path "/etc/init/zookeeper.conf"
  mode "0644"
  notifies :run, "execute[init-reload]"
end

template "zookeeper.properties" do
  path "/etc/precog/zookeeper.cfg"
  mode "0644"
  notifies :restart, "service[zookeeper]"
end

service "zookeeper" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

