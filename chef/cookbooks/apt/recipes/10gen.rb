#
# Cookbook Name:: apt
# Recipe:: 10gen
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
apt_repository "10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
end

