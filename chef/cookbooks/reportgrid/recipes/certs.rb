#
# Cookbook Name:: reportgrid
# Recipe:: certs
#
# Copyright 2013, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_ssl"

owner_name = if platform?("ubuntu", "debian") "www-data" else "root" end

directory "/etc/apache2/ssl" do
  owner owner_name
  mode "755"
end

cookbook_file "/etc/apache2/ssl/reportgrid.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.ca.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.key" do
  owner owner_name
  mode "400"
end

