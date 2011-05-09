#
# Cookbook Name:: mongodb
# Recipe:: opricot
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "php::mongo"

remote_file "opricot" do
  source "#{node[:mongodb][:opricot][:dist_remote]}"
  path "#{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]}.zip"
  mode "0644"
  not_if { File.file?("#{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]}.zip") }
end

execute "opricot-extract" do
  command "/usr/bin/unzip #{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]} -d #{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]}"
  not_if { File.directory?("#{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]}") }
end

link "opricot" do
  to "#{node[:mongodb][:data_mount_point]}/opricot-#{node[:mongodb][:opricot][:version]}/mongoconsole"
  target_file "#{node[:mongodb][:data_mount_point]}/opricot"
  not_if { File.exists?("#{node[:mongodb][:data_mount_point]}/opricot") }
end
