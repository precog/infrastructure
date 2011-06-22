#
# Cookbook Name:: mdadm
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "mdadm" do
  package_name "mdadm"
end

template "mdadm.conf" do
  source "mdadm.conf.erb"
  path "/etc/mdadm/mdadm.conf"
  mode "0644"
end
