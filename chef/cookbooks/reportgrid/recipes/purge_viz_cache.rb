#
# Cookbook Name:: reportgrid
# Recipe:: purge_viz_cache
#
# Copyright 2012, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"

cron "purge_global" do
  minute "37"
  command "curl -Gs 'http://api.reportgrid.com/services/viz/charts/maintenance/cache/purge?auth=6kdsbgv46272'"
  mailto "operations@reportgrid.com"
end

cron "purge_expired" do
  minute "27"
  command "curl -Gs 'http://api.reportgrid.com/services/viz/charts/maintenance/renderables/purge/expired?auth=6kdsbgv46272'"
  mailto "operations@reportgrid.com"
end

cron "purge_unused" do
  minute "17"
  hour "4"
  command "curl -Gs 'http://api.reportgrid.com/services/viz/charts/maintenance/renderables/purge/unused?auth=6kdsbgv46272'"
  mailto "operations@reportgrid.com"
end

