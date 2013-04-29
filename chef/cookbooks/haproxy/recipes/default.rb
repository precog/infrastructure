#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2010-2011, ReportGrid
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

# Setup and generation for haproxy.cfg 
appservers = search(:node, "(role:appserver* OR roles:appserver*) AND chef_environment:#{node.chef_environment}").map { |n| n[:fqdn] }

# haproxy should at least reference localhost
if appservers.length == 0 then
  appservers = [node[:fqdn]]
end

services = {
  ['analytics', 'v1'] => {
    :servers => appservers,
    :port    => 30020
  },
  ['jessup', 'v1'] => {
    :servers => appservers,
    :port    => 30030
  },
  ['billing', 'v1'] => {
    :servers => appservers,
    :port    => 30040
  },
  ['vistrack', 'v1'] => {
    :servers => appservers,
    :port    => 30050
  }
}

services.each do |k, v|
  munin_haproxy k[0] do
    backend "services_#{k.join("_")}"
  end
end

template "haproxy.cfg" do
  variables(
    :services => services 
  )
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

template "21-haproxy.conf" do
  source "21-haproxy.conf.erb"
  path "/etc/rsyslog.d/21-haproxy.conf"
  mode "0644"
  notifies :restart, resources(:service => "rsyslog")
end

template "haproxy.logrotate" do
  source "haproxy.logrotate.erb"
  path "/etc/logrotate.d/haproxy"
  mode "0644"
end
