#
# Cookbook Name:: precog
# Recipe:: ssl_proxy
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::certs"
# These enable the relevant modules
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

web_app "ssl_proxy_localhost" do
  server_name "api.precog.com"
  server_aliases [node['fqdn']]
  template "ssl_proxy_localhost.conf.erb"
end
