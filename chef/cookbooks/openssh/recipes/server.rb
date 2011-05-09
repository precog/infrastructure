#
# Cookbook Name:: openssh
# Recipe:: server
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "openssh-server" do
  package_name "openssh-server"
end

service "openssh-server" do
  service_name "ssh"
  action :enable
end

template "sshd_config" do
  source "sshd_config.erb"
  path "/etc/ssh/sshd_config"
  mode "0644"
  notifies :restart, resources(:service => "openssh-server")
end

template "openssh-server.monit" do
  source "openssh-server.monit.erb"
  path "/etc/monit/conf.d/openssh-server.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
