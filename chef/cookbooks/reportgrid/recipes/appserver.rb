#
# Cookbook Name:: reportgrid
# Recipe:: appserver
#
# Copyright 2010-2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "reportgrid::baseenv"

cookbook_file "/opt/reportgrid/GeoLiteCity.dat" do
  source "GeoLiteCity.dat"
  mode "0644"
end

blueeyes_service "analytics-v0" do
  port "30010"
end

blueeyes_service "analytics-v1" do
  port "30020"
  jar_file "analytics-assembly-1.2.6-SNAPSHOT.jar"
end

blueeyes_service "jessup-v1" do
  port "30030"
  memory 256
end

