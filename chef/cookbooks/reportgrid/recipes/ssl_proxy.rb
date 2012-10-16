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
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_rewrite"

owner_name = if platform?("ubuntu", "debian") "www-data" else "root" end

directory "/etc/apache2/ssl" do
  owner owner_name
  mode "755"
end

cookbook_file "/etc/apache2/ssl/reportgrid.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.ca.cert" do
  owner owner_name
  mode "444"
end

cookbook_file "/etc/apache2/ssl/reportgrid.key" do
  owner owner_name
  mode "400"
end

web_app "ssl_proxy_localhost" do
  server_name "api.reportgrid.com"
  server_aliases [node['fqdn']]
  template "ssl_proxy_localhost.conf.erb"
end
