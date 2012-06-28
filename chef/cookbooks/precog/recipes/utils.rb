#
# Cookbook Name:: precog
# Recipe:: utils
#
# Copyright 2011, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::baseenv"

cookbook_file "/opt/precog/threaddump.sh" do
  mode "755"
end
