#
# Cookbook Name:: apt
# Recipe:: 10gen
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
apt_repository "opscode" do
  uri "http://apt.opscode.com/"
  distribution "#{node['lsb']['codename']}-0.10"
  components ["main"]
  key "http://apt.opscode.com/packages@opscode.com.gpg.key"
  deb_src true
end

