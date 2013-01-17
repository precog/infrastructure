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
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_rewrite"
include_recipe "reportgrid::certs"

web_app "ssl_reportgrid_proxy_localhost" do
  server_name "api.reportgrid.com"
  server_aliases [node['fqdn']]
  template "ssl_reportgrid_proxy_localhost.conf.erb"
end
