#
# Cookbook Name:: precog
# Recipe:: developersredirect
#
# Copyright 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::nginxcerts"
include_recipe "nginx::repo"
include_recipe "nginx"

template "#{node['nginx']['dir']}/sites-available/developers" do
  source "developersredirect.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

nginx_site 'developers' do
  enable true
end

