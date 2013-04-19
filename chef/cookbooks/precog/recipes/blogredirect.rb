#
# Cookbook Name:: precog
# Recipe:: blogredirect
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::nginxcerts"
include_recipe "nginx::repo"
include_recipe "nginx"

directory '/var/www/precogsite' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/precogsite/releases' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/etc/nginx/redirects.d' do
  owner 'root'
  group 'root'
  mode 0755
end

link '/etc/nginx/redirects.d/blog.conf' do
  to '/var/www/precogsite/current/blogredirects.conf'
end

template "#{node['nginx']['dir']}/sites-available/blog" do
  source "blogredirect.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, 'service[nginx]'
end

nginx_site 'blog' do
  enable true
end

