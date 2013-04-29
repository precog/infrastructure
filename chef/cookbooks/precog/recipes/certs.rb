#
# Cookbook Name:: precog
# Recipe:: certs
#
# Copyright 2012, 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_ssl"

if platform?("ubuntu", "debian")
	owner_name = "www-data"
else
	owner_name = "root"
end

directory "/etc/apache2/ssl" do
  owner owner_name
  mode "755"
end

cookbook_file "/etc/apache2/ssl/precog.cert" do
  owner owner_name
  mode "444"
  notifies :reload, "service[apache2]"
end

cookbook_file "/etc/apache2/ssl/precog.ca.cert" do
  owner owner_name
  mode "444"
  notifies :reload, "service[apache2]"
end

cookbook_file "/etc/apache2/ssl/precog.key" do
  owner owner_name
  mode "400"
  notifies :reload, "service[apache2]"
end

