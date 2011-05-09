#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2010, ReportGrid.com
#
# All rights reserved - Do Not Redistribute
#
template "hosts" do
  source "hosts.erb"
  path "/etc/hosts"
  mode "0644"
end

template "hostname" do
  source "hostname.erb"
  path "/etc/hostname"
  mode "0644"
end
