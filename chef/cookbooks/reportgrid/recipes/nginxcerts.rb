#
# Cookbook Name:: reportgrid
# Recipe:: nginxcerts
#
# Copyright 2012, 2013, Reportgrid, inc
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

cookbook_file "/etc/nginx/ssl/reportgrid.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/nginx/ssl/reportgrid.ca.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/nginx/ssl/reportgrid.key" do
  owner owner_name
  mode "400"
end

