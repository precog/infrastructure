#
# Cookbook Name:: precog
# Recipe:: ssl_reportgrid_proxy
#
# Copyright 2012, 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::certs"
# These enable the relevant modules
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

web_app "ssl_reportgrid_proxy_localhost" do
  server_name "api.reportgrid.com"
  server_aliases [node['fqdn']]
  template "ssl_reportgrid_proxy_localhost.conf.erb"
end
