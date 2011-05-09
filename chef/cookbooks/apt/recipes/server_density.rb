#
# Cookbook Name:: apt
# Recipe:: server_density
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "server_density_key" do
  command "/usr/bin/curl -s http://www.serverdensity.com/downloads/boxedice-public.key | /usr/bin/apt-key add -"
  not_if "/usr/bin/apt-key list | grep 'boxedice.com'"
end

template "server_density.list" do
  source "server_density.list.erb"
  path "/etc/apt/sources.list.d/server_density.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
end
