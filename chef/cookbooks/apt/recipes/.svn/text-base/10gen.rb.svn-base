#
# Cookbook Name:: apt
# Recipe:: 10gen
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "10gen_key" do
  command "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
  not_if "/usr/bin/apt-key list | grep '10gen.com'"
end

template "10gen.list" do
  source "10gen.list.erb"
  path "/etc/apt/sources.list.d/10gen.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
end
