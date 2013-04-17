#
# Cookbook Name:: wintersmith
# Recipe:: default
#
# Copyright 2013, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

execute "install_wintersmith" do
  command "npm install wintersmith -g"
  not_if do
    File.exists?("/usr/bin/wintersmith")
  end
end
