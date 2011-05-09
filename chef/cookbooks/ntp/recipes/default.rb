#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "ntp" do
  package_name "ntp"
end

service "ntp" do
  service_name "ntp"
  action :enable
end
