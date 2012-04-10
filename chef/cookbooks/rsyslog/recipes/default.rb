#
# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

package "rsyslog" do
  package_name "rsyslog"
end

service "rsyslog" do
  service_name "rsyslog"
  action :enable
end

directory node[:rsyslog][:work_dir] do
  path node[:rsyslog][:work_dir]
  if node['platform'] != 'centos' then
    owner "syslog"
  end
end

template "rsyslog.conf" do
  source "rsyslog.conf.erb"
  path "/etc/rsyslog.conf"
  mode "0644"
  notifies :restart, resources(:service => "rsyslog")
end

template "50-default.conf" do
  source "50-default.conf.erb"
  path "/etc/rsyslog.d/50-default.conf"
  mode "0644"
  notifies :restart, resources(:service => "rsyslog")
end

template "rsyslog.monit" do
  source "rsyslog.monit.erb"
  path "/etc/monit/conf.d/rsyslog.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
