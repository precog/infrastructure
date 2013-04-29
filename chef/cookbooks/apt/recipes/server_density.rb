#
# Cookbook Name:: apt
# Recipe:: 10gen
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
apt_repository "server_density" do
  uri "http://www.serverdensity.com/downloads/linux/debian"
  distribution node['lsb']['codename']
  components ["main"]
  key "http://www.serverdensity.com/downloads/boxedice-public.key"
end

