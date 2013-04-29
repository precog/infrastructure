#
# Cookbook Name:: haproxyV2
# Recipe:: default
#
# Copyright 2010-2012, ReportGrid
#
# All rights reserved - Do Not Redistribute

include_recipe "haproxyV2::certs"

package "haproxy"
package "socat"

%w{security, accounts, jobs, query, ingest}.each do |service|
  munin_haproxy service do
    backend "service_#{service}"
  end
end

directory "/var/lib/haproxy" do
  owner "haproxy"
  group "haproxy"
  mode "755"
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
