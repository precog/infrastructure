#
# Cookbook Name:: reportgrid
# Recipe:: vistrack
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "reportgrid::baseenv"

blueeyes_service "vistrack-v1" do
  port "30050"
  memory 512
  jar_file "vistrack-assembly-1.0.0-SNAPSHOT.jar"
end
