#
# Cookbook Name:: precog
# Recipe:: usagereport
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::baseenv"

# We use mutt to send attachments with email
package "mutt"

cookbook_file "/opt/precog/usageReport.sh" do
  mode "0755"
end

# just do it manually for now
#cron "Run shard usage report" do
#  weekday "1"
#  hour "1"
#  minute "0"
#  command "/opt/precog/usageReport.sh ..."
#end
