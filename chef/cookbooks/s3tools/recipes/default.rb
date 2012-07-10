#
# Cookbook Name:: s3tools
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
if platform?("ubuntu","debian")
  include_recipe "apt::s3tools"
end

package "s3cmd" do
  package_name "s3cmd"
end

template "s3cfg" do
  source "s3cfg.erb"
  path "/root/.s3cfg"
  mode "0600"
end
