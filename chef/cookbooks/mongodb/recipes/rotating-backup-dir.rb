#
# Cookbook Name:: mongodb
# Recipe:: rotating-backup-dir
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
directory "mongodb_rotating_dir" do
  path "#{node[:ec2][:ephemeral_backups]}/mongodb-rotating/"
  owner 'mongodb'
  group 'mongodb'
  mode '755'
  recursive true
end
