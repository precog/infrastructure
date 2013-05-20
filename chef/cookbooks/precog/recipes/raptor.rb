#
# Cookbook Name:: precog
# Recipe:: raptor
#
# Copyright 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_alias"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_expires"

directory "#{node[:precog][:raptor][:root]}" do
  recursive true
  owner "ubuntu"
  group "www-data"
  mode  "6755"
end

web_app "raptor" do
  server_name node['fqdn']
  server_aliases ["labraptor.precog.com", "devlabraptor.precog.com"]
  docroot "#{node[:precog][:raptor][:root]}/current/"
  template "raptor.conf.erb"
end


