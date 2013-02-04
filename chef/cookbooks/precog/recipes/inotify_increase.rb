#
# Cookbook Name:: precog
# Recipe:: baseenv
#
# Copyright 2011, Precog
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sysctl"

directory "/etc/sysctl.d" do
  owner "root"
  group "root"
  mode "755"
end

cookbook_file "/etc/sysctl.d/60-inotify-limits.conf" do
  ignore_failure true
  mode "0644"
  # TODO: Make this work for RH-derivatives
  notifies :start, "service[procps]"
end
