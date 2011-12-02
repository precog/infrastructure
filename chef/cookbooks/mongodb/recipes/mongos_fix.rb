#
# Cookbook Name:: mongodb
# Recipe:: mongos_fix
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
cookbook_file "/usr/bin/mongos" do
  owner "root"
  group "root"
  mode "755"
end
