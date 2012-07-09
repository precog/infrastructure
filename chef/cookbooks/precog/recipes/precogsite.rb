#
# Cookbook Name:: reportgrid
# Recipe:: precogsite
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
# These enable the relevant modules
include_recipe "apache2::mod_php5"

directory "/var/www/precogsite" do
  recursive true
  owner "ubuntu"
  group "www-data"
  mode  "755"
end

web_app "precogsite" do
  server_name "www.precog.com"
  server_aliases ["precog.com","site.precog.com"]
  template "precogsite.conf.erb"
  docroot "/var/www/precogsite"
end
