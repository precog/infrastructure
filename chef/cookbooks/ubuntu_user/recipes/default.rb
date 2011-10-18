#
# Cookbook Name:: ubuntu_user
# Recipe:: default
#
# Copyright 2011, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

group "ubuntu"

user "ubuntu" do
  gid "ubuntu"
  home "/home/ubuntu"
  supports :manage_home => "true"
end

directory "/home/ubuntu/.ssh" do
  owner "ubuntu"
  group "ubuntu"
  mode "0700"
end

cookbook_file "/home/ubuntu/.ssh/authorized_keys" do
  owner "ubuntu"
  group "ubuntu"
  mode "0600"
end
