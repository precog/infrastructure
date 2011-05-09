#
# Cookbook Name:: apt
# Recipe:: opscode
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "opscode_key" do
  command "/usr/bin/curl -s http://apt.opscode.com/packages@opscode.com.gpg.key | /usr/bin/apt-key add -"
  not_if "/usr/bin/apt-key list | grep 'opscode.com'"
end

template "opscode.list" do
  source "opscode.list.erb"
  path "/etc/apt/sources.list.d/opscode.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
end
