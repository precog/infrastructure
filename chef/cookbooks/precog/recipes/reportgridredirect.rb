#
# Cookbook Name:: precog
# Recipe:: reportgridredirect
#
# Copyright 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::nginxcerts"
include_recipe "nginx::repo"
include_recipe "nginx"

template "#{node['nginx']['dir']}/sites-available/reportgrid" do
  source "reportgridredirect.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

nginx_site 'reportgrid' do
  enable true
end

