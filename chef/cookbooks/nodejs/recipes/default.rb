#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2013, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#
execute "chrislea_key" do
  command "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv C7917B12"
  not_if "/usr/bin/apt-key list | grep 'chrislea'"
end

cookbook_file "/etc/apt/sources.list.d/chris-lea-node_js-precise.list" do
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
end

package "nodejs"
