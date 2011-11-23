#
# Cookbook Name:: reportgrid
# Recipe:: token_delta_check
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"

script = "/opt/reportgrid/checkTokenDelta.sh"

cookbook_file script do
  mode "755"
end

cron "checkTokenDelta" do
  minute "*/30"
  command script
  mailto "operations@reportgrid.com"
end
