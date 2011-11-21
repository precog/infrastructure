#
# Cookbook Name:: reportgrid
# Recipe:: tokenmaintenance
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"

template "/opt/reportgrid/setTokens.js" do
  owner "reportgrid"
  mode 600
end

cron "Ensure service tokens" do
  minute "*/10"
  command "mongo analytics1 /opt/reportgrid/setTokens.js > /dev/null"
  mailto "derek@reportgrid.com"
end


