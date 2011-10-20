#
# Cookbook Name:: xvfb
# Recipe:: default
#
# Copyright 2011, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

package "xvfb"

cookbook_file "/etc/init/xvfb.conf"

link "xvfb" do
  to "/lib/init/upstart-job"
  target_file "/etc/init.d/xvfb"
end

service "xvfb" do
  service_name "xvfb"
  action [:enable, :start]
end
