#
# Cookbook Name:: precog
# Recipe:: blogsite
#
# Copyright 2013, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "precog::certs"
# These enable the relevant modules
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

web_app "blogsite" do
  server_name "blog.precog.com"
  server_aliases ["web3.precog.com"]
  template "blogsite.conf.erb"
end
