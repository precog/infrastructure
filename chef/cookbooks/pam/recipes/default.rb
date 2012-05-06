#
# Cookbook Name:: pam
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
template "limits.conf" do
  source "limits.conf.erb"
  path "/etc/security/limits.conf"
  mode "0644"
end

# Make sure we log login/logout data
file "/var/log/wtmp" do
  action :create_if_missing
  backup false
  owner "root"
  group "root"
  mode "0644"
end
  
