#
# Cookbook Name:: kafka
# Recipe:: baseenv
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "precog::baseenv"

directory "/opt/precog/kafka/lib" do
  owner "precog"
  recursive true
end

directory "/opt/precog/kafka/bin" do
  owner "precog"
  recursive true
end

directory "/var/log/kafka" do
  owner "precog"
  recursive true
end

directory "/var/kafka" do
  owner "precog"
  recursive true
end

cookbook_file "/opt/precog/kafka/lib/kafka-core-assembly-0.7.5.jar" do
  owner "precog"
  mode  "0644"
end

cookbook_file "/opt/precog/kafka/bin/kafka-server-start.sh" do
  owner "precog"
  mode "0755"
end
