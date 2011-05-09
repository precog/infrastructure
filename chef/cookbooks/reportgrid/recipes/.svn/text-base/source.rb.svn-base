#
# Cookbook Name:: reportgrid
# Recipe:: source
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "subversion"

directory "source_root" do
  path node[:reportgrid][:source][:root]
  mode '755'
end