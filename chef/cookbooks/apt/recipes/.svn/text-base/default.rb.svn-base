#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "aptitude_update" do
  command "/usr/bin/aptitude update"
  action :nothing
end

template "sources.list" do
  source "sources.list.erb"
  path "/etc/apt/sources.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
  ignore_failure true
end

package "unattended-upgrades" do
  package_name "unattended-upgrades"
end

template "10periodic" do
  source "10periodic.erb"
  path "/etc/apt/apt.conf.d/10periodic"
  mode "0644"
end

template "50unattended-upgrades" do
  source "50unattended-upgrades.erb"
  path "/etc/apt/apt.conf.d/50unattended-upgrades"
  mode "0644"
end
