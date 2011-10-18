#
# Cookbook Name:: at
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

package "at" do
  action :install
end

service "atd" do
  service_name "atd"
  action :enable
end
