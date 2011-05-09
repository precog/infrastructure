#
# Cookbook Name:: server_density
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::server_density"

package "sd-agent" do
  package_name "sd-agent"
end

service "sd-agent" do
  service_name "sd-agent"
  action :enable
end

template "sd-agent_config" do
  source "config.cfg.erb"
  path "/etc/sd-agent/config.cfg"
  mode "0644"
  notifies :restart, resources(:service => "sd-agent")
end