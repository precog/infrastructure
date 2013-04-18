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

directory "/var/www/staticsite" do
  recursive true
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

