#
# Cookbook Name:: apt
# Recipe:: 10gen
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
apt_repository "s3tools" do
  uri "http://s3tools.org/repo/deb-all"
  distribution "stable/"
  key "http://s3tools.org/repo/deb-all/stable/s3tools.key"
end

