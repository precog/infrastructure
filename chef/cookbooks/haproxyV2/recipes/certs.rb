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

if platform?("ubuntu", "debian")
        owner_name = "haproxy"
else
        owner_name = "root"
end

directory "/etc/haproxy/certs" do
  owner owner_name
  mode "755"
end

cookbook_file "/etc/haproxy/precog-chain.pem" do
  owner owner_name
  mode "440"
end

cookbook_file "/etc/haproxy/certs/reportgrid-chain.pem" do
  owner owner_name
  mode "440"
end

