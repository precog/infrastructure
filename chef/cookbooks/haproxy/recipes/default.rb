#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "haproxy" do
  package_name "haproxy"
end

service "haproxy" do
  service_name "haproxy"
  action :enable
  supports :reload => true
end

template "haproxy.default" do
  source "haproxy.default.erb"
  path "/etc/default/haproxy"
  mode "0644"
  notifies :restart, resources(:service => "haproxy")
end

template "haproxy.cfg" do
  source "haproxy.cfg.erb"
  path "/etc/haproxy/haproxy.cfg"
  mode "0644"
  notifies :reload, resources(:service => "haproxy")
end

template "haproxy.monit" do
  source "haproxy.monit.erb"
  path "/etc/monit/conf.d/haproxy.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
