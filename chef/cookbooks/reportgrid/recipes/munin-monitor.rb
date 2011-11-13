#
# Cookbook Name:: reportgrid
# Recipe:: munin-monitor
#
# Copyright 2011, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "munin::client"

service_monitor "analytics-v1"
