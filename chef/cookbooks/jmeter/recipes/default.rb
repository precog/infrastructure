#
# Cookbook Name:: jmeter
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"

package "jmeter-http"

package "jmeter-junit"

package "jmeter-java"

execute "initctl-reload" do
  action :nothing
  command "initctl reload-configuration"
end

cookbook_file "/etc/init/jmeter-server.conf" do
  notifies :run, "execute[initctl-reload]"
  notifies :restart, "service[jmeter-server]"
end

link params[:name] do
  to "/lib/init/upstart-job"
  target_file "/etc/init.d/jmeter-server"
end

service "jmeter-server" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
