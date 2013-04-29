#
# Cookbook Name:: precog
# Recipe:: nginxcerts
#
# Copyright 2012, 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "nginx"

if platform?("ubuntu", "debian")
	owner_name = "www-data"
else
	owner_name = "root"
end

directory "/etc/nginx/ssl" do
  owner owner_name
  mode "755"
end

cookbook_file "/etc/nginx/ssl/precog.cert" do
  owner owner_name
  mode "444"
  notifies :reload, "service[nginx]"
end

cookbook_file "/etc/nginx/ssl/precog.ca.cert" do
  owner owner_name
  mode "444"
  notifies :reload, "service[nginx]"
end

cookbook_file "/etc/nginx/ssl/precog.key" do
  owner owner_name
  mode "400"
  notifies :reload, "service[nginx]"
end

