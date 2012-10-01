#
# Cookbook Name:: kafka
# Recipe:: central
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

template "/etc/precog/kafka-central-log4j.properties" do
  source "log4j.properties.erb"
  mode   "0644"
  variables(
    :instance_name => "central"
  )
end

template "/etc/precog/precog.central-kafka.properties" do
  mode "0644"
  notifies :restart, "service[kafka_central]"
end

template "/etc/init/kafka_central.conf" do
  mode "0644"
  notifies :run, "execute[init-reload]"
end

service "kafka_central" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
