#
# Cookbook Name:: sysstat
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "sysstat" do
  package_name "sysstat"
end

service "sysstat" do
  service_name "sysstat"
  action :enable
end

template "sysstat" do
  source "sysstat.default.erb"
  path "/etc/default/sysstat"
  mode "0644"
  notifies :restart, resources(:service => "sysstat")
end
