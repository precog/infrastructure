#
# Cookbook Name:: reportgrid
# Recipe:: appserver_log_backup
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

cron "sync_app_logs_to_s3" do
  command "s3cmd sync --no-delete-removed --no-progress --exclude='*' --include='analytics-v1-2*' /var/log/reportgrid/ s3://ops.reportgrid.com/logs/`hostname`/ > /dev/null"
  hour 1
  minute 7
end
