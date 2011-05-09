#
# Cookbook Name:: openssh
# Recipe:: client
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "openssh-client" do
  package_name "openssh-client"
end

template "ssh_config" do
  source "ssh_config.erb"
  path "/etc/ssh/ssh_config"
  mode "0644"
end
