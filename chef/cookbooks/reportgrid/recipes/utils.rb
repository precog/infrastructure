#
# Cookbook Name:: reportgrid
# Recipe:: utils
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"

cookbook_file "/opt/reportgrid/threaddump.sh" do
  mode "755"
end
