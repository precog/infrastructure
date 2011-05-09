#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "nginx" do
  package_name "nginx"
end

service "nginx" do
  service_name "nginx"
  action :enable
end

template "nginx.monit" do
  source "nginx.monit.erb"
  path "/etc/monit/conf.d/nginx.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
