#
# Cookbook Name:: mongodb
# Recipe:: events-backup
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
include_recipe "reportgrid::baseenv"
include_recipe "s3tools"
include_recipe "mongodb::rotating-backup-dir"

template "/opt/reportgrid/mongodb-events-backup.sh" do
  owner "mongodb"
  mode "744"
end

cron "backup_events" do
  hour "1"
  minute "27"
  command "/opt/reportgrid/mongodb-events-backup.sh > /var/log/mongodb/mongodb-events-backup-`date '+%F'`.log"
end
