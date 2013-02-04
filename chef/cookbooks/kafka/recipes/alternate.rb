#
# Cookbook Name:: kafka
# Recipe:: default (alternate local kafka)
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "kafka::baseenv"

instance_name = "local2"
port_number = "9102"
logdir = "/var/kafka/#{instance_name}/logs"
broker_id = "2"

execute "init-reload" do
  action :nothing
  command "initctl reload-configuration"
end

template "/etc/precog/kafka-#{instance_name}-log4j.properties" do
  source "log4j.properties.erb"
  mode   "0644"
  variables(
    :instance_name => instance_name
  )
end

template "/etc/precog/precog.#{instance_name}-kafka.properties" do
  source "precog.kafka.properties.erb"
  mode "0644"
  notifies :restart, "service[kafka_#{instance_name}]"
  variables(
    :logdir      => logdir,
    :port_number => port_number,
    :zookeeper   => "true",
    :broker_id   => broker_id
  )
end

directory logdir do
  owner "precog"
  group "precog"
  mode "0644"
  recursive true
end

template "/etc/init/kafka_#{instance_name}.conf" do
  source "kafka.conf.erb"
  mode "0644"
  notifies :run, "execute[init-reload]"
  variables(
    :instance_name => instance_name
  )
end

service "kafka_#{instance_name}" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

# vim: et sw=2 ts=2 sts=2
