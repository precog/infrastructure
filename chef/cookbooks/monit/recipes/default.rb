#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "monit" do
  package_name "monit"
end

service "monit" do
  service_name "monit"
  action :enable
end

template "monit" do
  source "monit.erb"
  path "/etc/default/monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

directory "/etc/monit/conf.d" do
  owner "root"
  mode "0755"
  recursive true
end

template "monitrc" do
  source "monitrc.erb"
  if node['platform'] == 'centos' then
    path "/etc/monit.conf"
  else
    path "/etc/monit/monitrc"
  end
  mode "0600"
  notifies :restart, resources(:service => "monit")
end

template "system.monit" do
  source "system.monit.erb"
  path "/etc/monit/conf.d/system.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

# Ensure that no service stays unmonitored for long
cron "monit-monitor-all" do
  command "/usr/bin/env monit monitor all"
  minute "0"
  hour "0"
end
