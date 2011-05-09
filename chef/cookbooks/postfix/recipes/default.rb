#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "postfix" do
  package_name "postfix"
end

service "postfix" do
  service_name "postfix"
  action :enable
end

template "main.cf" do
  source "main.cf.erb"
  path "/etc/postfix/main.cf"
  mode "0644"
  notifies :restart, resources(:service => "postfix")
end

execute "newaliases" do
  command "/usr/bin/newaliases"
  action :nothing
end

template "aliases" do
  source "aliases.erb"
  path "/etc/aliases"
  mode "0644"
  notifies :run, resources(:execute => "newaliases"), :immediately
end

template "generic" do
  source "generic.erb"
  path "/etc/postfix/generic"
  mode "0644"
end

execute "postmap_sasl_passwd" do
  command "/usr/sbin/postmap hash:/etc/postfix/sasl_passwd"
  action :nothing
end

template "sasl_passwd" do
  source "sasl_passwd.erb"
  path "/etc/postfix/sasl_passwd"
  mode "0644"
  notifies :run, resources(:execute => "postmap_sasl_passwd"), :immediately
end

template "postfix.monit" do
  source "postfix.monit.erb"
  path "/etc/monit/conf.d/postfix.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
