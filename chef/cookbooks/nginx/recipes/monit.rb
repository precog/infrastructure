#
# Cookbook Name:: nginx
# Recipe:: monit
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/monit/conf.d/nginx.monit" do
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
