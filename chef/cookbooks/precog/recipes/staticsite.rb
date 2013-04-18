#
# Cookbook Name:: precog
# Recipe:: staticsite
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::nginxcerts"
include_recipe "nginx::repo"
include_recipe "nginx"

directory "/var/www/precogsite" do
  recursive true
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

template "#{node['nginx']['dir']}/sites-available/staticsite" do
  source "staticsite.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

nginx_site 'staticsite' do
  enable true
end

