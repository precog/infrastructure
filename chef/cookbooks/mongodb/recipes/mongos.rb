#
# Cookbook Name:: mongodb
# Recipe:: mongos
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "mongodb"

if node[:mongodb][:mongos_enabled] == "yes" then
  template "mongos.conf.init" do
    source "mongos.conf.init.erb"
    path "/etc/init/mongos.conf"
    mode "0644"
  end

  link "mongos" do
    to "/lib/init/upstart-job"
    target_file "/etc/init.d/mongos"
  end

  template "mongos.default" do
    source "mongos.default.erb"
    path "/etc/default/mongos"
    mode "0644"
  end

  service "mongos" do
    service_name "mongos"
    action :enable
  end

  template "mongos.conf" do
    variables(:config_servers => search(:node, "environment:#{node[:environment]} AND role:mongodb-config-server").map { |attr| "%s:%d" % [ attr['fqdn'], node[:mongodb][:port][:config] ] })
    source "mongos.conf.erb"
    path "/etc/mongos.conf"
    mode "0644"
    notifies :restart, resources(:service => "mongos")
  end

  template "mongos.monit" do
    source "mongos.monit.erb"
    path "/etc/monit/conf.d/mongos.monit"
    mode "0644"
    notifies :restart, resources(:service => "monit")
  end

  template "mongodb.logrotate" do
    variables(
      :log_dir => "/var/log/mongodb"
    )
    source "mongodb.logrotate.erb"
    path "/etc/logrotate.d/mongodb"
    mode "0644"
  end
end
