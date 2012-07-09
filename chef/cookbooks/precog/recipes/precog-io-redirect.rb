#
# Cookbook Name:: precog
# Recipe:: precog-io-redirect
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

web_app "precog-io-redirect" do
  server_name "precog.io"
  server_aliases ["www.precog.io","precog.ai", "www.precog.ai"]
  docroot "/var/www/"
  template "precog-io-redirect.conf.erb"
end


