#
# Cookbook Name:: reportgrid
# Recipe:: billing
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "reportgrid::baseenv"

blueeyes_service "billing-v1" do
  port "30040"
  memory 1024
  jar_file "billing-1.0.0.jar"
end
