#
# Cookbook Name:: mongodb
# Recipe:: token-backup
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute

directory "mongodb_token_backups" do
  path "#{node[:ec2][:ephemeral_backups]}/mongodb-rotating/"
  owner 'mongodb'
  group 'mongodb'
  mode '755'
  recursive true
end

if node[:recipes].include?('mongodb::config-server')
  port = node[:mongodb][:port][:config]
elsif node[:recipes].include?('mongodb::shard-server')
  port = node[:mongodb][:port][:shard]
else
  port = node[:mongodb][:port][:standalone]
end

template "/etc/mongodb-backup-tokens.js" do
  variables(
    :port => port
  )
  mode "644"
end


cron "mongodb-token-backup" do
  command "/usr/bin/mongo --port #{port} config /etc/mongodb-backup-tokens.js > #{node[:mongodb][:data_mount_point]}/logs/mongodb-token-backup.log 2>&1"
  minute 0
  hour 9
  user "mongodb"
end

