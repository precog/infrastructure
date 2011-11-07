#
# Cookbook Name:: reportgrid
# Recipe:: ssl_proxy
#
# Copyright 2010-2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
# These enable the relevant modules
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_ssl"

cookbook_file "/etc/apache2/ssl/reportgrid.cert" do
  owner "www-data"
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.ca.cert" do
  owner "www-data"
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.key" do
  owner "www-data"
  mode "400"
end

web_app "ssl_proxy_localhost" do
  server_name "api.reportgrid.com"
  server_aliases [node['fqdn']]
  template "ssl_proxy_localhost.conf.erb"
end
