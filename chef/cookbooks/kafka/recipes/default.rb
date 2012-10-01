#
# Cookbook Name:: kafka
# Recipe:: default (local kafka)
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "kafka::baseenv"

execute "init-reload" do
  action :nothing
  command "initctl reload-configuration"
end

template "/etc/precog/kafka-local-log4j.properties" do
  source "log4j.properties.erb"
  mode   "0644"
  variables(
    :instance_name => "local"
  )
end

template "/etc/precog/precog.local-kafka.properties" do
  mode "0644"
  notifies :restart, "service[kafka_local]"
end

template "/etc/init/kafka_local.conf" do
  mode "0644"
  notifies :run, "execute[init-reload]"
end

service "kafka_local" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
