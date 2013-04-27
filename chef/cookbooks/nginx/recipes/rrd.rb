#
# Cookbook Name:: nginx
# Recipe:: rrd
#
# Copyright 2013, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx::http_stub_status_module"

package 'rrdtool'
package "librrds-perl"

template "/usr/local/bin/rrd_nginx.pl" do
  mode "0755"
end

cron "/usr/local/bin/rrd_nginx.pl"

directory node['nginx']['rrd']['output_path'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
  mode 6755
end

directory node['nginx']['rrd']['database_path'] do
  owner 'root'
  group 'root'
  recursive true
  mode 755
end

