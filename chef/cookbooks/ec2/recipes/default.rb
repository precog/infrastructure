#
# Cookbook Name:: ec2
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

directory "ephemeral_backups" do
  path node[:ec2][:ephemeral_backups]
end

cron "ephemeral_storage_test" do
  command '(/bin/date > /mnt/.ephemeral_storage_test; if [ "$?" -eq "0" ]; then /bin/echo "ok"; else /bin/echo "error"; fi) > /var/log/ephemeral_storage_test.log 2>&1'
end
