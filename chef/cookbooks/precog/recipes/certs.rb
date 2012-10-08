#
# Cookbook Name:: precog
# Recipe:: certs
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_ssl"

cookbook_file "/etc/apache2/ssl/precog.cert" do
  owner "www-data"
  mode "444"
end

cookbook_file "/etc/apache2/ssl/precog.ca.cert" do
  owner "www-data"
  mode "444"
end

cookbook_file "/etc/apache2/ssl/precog.key" do
  owner "www-data"
  mode "400"
end

