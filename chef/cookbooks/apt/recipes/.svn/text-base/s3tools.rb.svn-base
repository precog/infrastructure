#
# Cookbook Name:: apt
# Recipe:: s3tools
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "s3tools_key" do
  command "/usr/bin/curl -s http://s3tools.org/repo/deb-all/stable/s3tools.key | /usr/bin/apt-key add -"
  not_if "/usr/bin/apt-key list | grep 's3tools.org'"
end

template "s3tools.list" do
  source "s3tools.list.erb"
  path "/etc/apt/sources.list.d/s3tools.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
end
