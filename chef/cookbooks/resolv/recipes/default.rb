#
# Cookbook Name:: resolv
# Recipe:: default
#
# Copyright 2010, ReportGrid.com
#
# All rights reserved - Do Not Redistribute
#
template "resolv.conf" do
  source "resolv.conf.erb"
  path "/etc/resolv.conf"
  mode "0644"
end
