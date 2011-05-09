#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::10gen"

template "mongodb.conf.init" do
  source "mongodb.conf.init.erb"
  path "/etc/init/mongodb.conf"
  mode "0644"
end

template "mongodb.default" do
  source "mongodb.default.erb"
  path "/etc/default/mongodb"
  mode "0644"
end

package "mongodb-10gen" do
  package_name "mongodb-10gen"
  version node[:mongodb][:version] if node[:mongodb].has_key?(:version)
  options '-o Dpkg::Options::="--force-confold"'
end