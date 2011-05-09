#
# Cookbook Name:: mongodb
# Recipe:: server
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
# FIXME: http://tickets.opscode.com/browse/CHEF-1565
mount node[:mongodb][:data_mount_point] do
  device node[:mongodb][:data_device]
  fstype "ext4"
  options "noatime"
  action :nothing
  only_if { File.blockdev?(node[:mongodb][:data_device]) && File.directory?(node[:mongodb][:data_mount_point]) }
end

directory node[:mongodb][:data_mount_point] do
  path node[:mongodb][:data_mount_point]
  notifies :enable, resources(:mount => node[:mongodb][:data_mount_point]), :immediately
  notifies :mount, resources(:mount => node[:mongodb][:data_mount_point]), :immediately
end

user "mongodb" do
  system true
  home "/var/lib/mongodb"
  shell "/bin/false"
  ignore_failure true # FIXME: fails if the user is logged in (ignore for now)
end

group "mongodb" do
  members ['mongodb']
end

['db', 'logs'].each do |subdir|
  directory subdir do
    path "#{node[:mongodb][:data_mount_point]}/#{subdir}"
    recursive true
    owner 'mongodb'
    group 'mongodb'
    mode '755'
  end
end

link "mongodb_db" do
  to "#{node[:mongodb][:data_mount_point]}/db"
  target_file "/var/lib/mongodb"
end

link "mongodb_logs" do
  to "#{node[:mongodb][:data_mount_point]}/logs"
  target_file "/var/log/mongodb"
end

template "mongodb.logrotate" do
  source "mongodb.logrotate.erb"
  path "/etc/logrotate.d/mongodb"
  mode "0644"
end

template "mongodb.conf" do
  source "mongodb.conf.erb"
  path "/etc/mongodb.conf"
  mode "0644"
end

include_recipe "mongodb"

service "mongodb" do
  service_name "mongodb"
  action :enable
end

template "mongodb.monit" do
  source "mongodb.monit.erb"
  path "/etc/monit/conf.d/mongodb.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

gem_package "mongo" do
  package_name "mongo"
end

gem_package "bson_ext" do
  package_name "bson_ext"
end

easy_install_package "pymongo" do
  package_name "pymongo"
end

cookbook_file "mongodb-health.rb" do
  source "mongodb-health.rb"
  path "/usr/local/bin/mongodb-health.rb"
  mode "0755"
end

cron "mongodb-health" do
  command "#/usr/local/bin/mongodb-health.rb >> #{node[:mongodb][:data_mount_point]}/logs/mongodb-health.log 2>&1"
  minute "*/15"
  user 'mongodb'
end

if node[:hostname].match(/[0-9]+/)[0].to_i % 3 == 2
  directory "mongodb_backups" do
    path "#{node[:ec2][:ephemeral_backups]}/mongodb/"
    owner 'mongodb'
    group 'mongodb'
    mode '755'
  end

  template "mongodb-backup.js" do
    source "mongodb-backup.js.erb"
    path "/etc/mongodb-backup.js"
    mode "0644"
  end

  if node[:recipes].include?('mongodb::config-server')
    port = node[:mongodb][:port][:config]
  elsif node[:recipes].include?('mongodb::shard-server')
    port = node[:mongodb][:port][:shard]
  else
    port = node[:mongodb][:port][:standalone]
  end

  cron "mongodb-backup" do
    command "/usr/bin/mongo --port #{port} config /etc/mongodb-backup.js > #{node[:mongodb][:data_mount_point]}/logs/mongodb-backup.log 2>&1"
    minute 0
    hour 9
    user "mongodb"
  end
end
