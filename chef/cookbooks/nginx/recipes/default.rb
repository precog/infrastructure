#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
add_apt_repo do
  url "ppa:nginx/stable"
end

package "nginx" do
  package_name "nginx-full"
end

directory "/var/nginx/cache" do
  owner "www-data"
  mode  "0700"
  recursive true
end

service "nginx" do
  service_name "nginx"
  action :enable
end

# Setup and generation for haproxy.cfg 
appservers = search(:node, "(role:appserver* OR roles:appserver*) AND chef_environment:#{node.chef_environment}").map { |n| n[:fqdn] }

# haproxy should at least reference localhost
if appservers.length == 0 then
  appservers = [node[:fqdn]]
end

services = {
  ['analytics', 'v1'] => {
    :servers => appservers,
    :port    => 30020
  },
  ['jessup', 'v1'] => {
    :servers => appservers,
    :port    => 30030
  },
  ['billing', 'v1'] => {
    :servers => appservers,
    :port    => 30040
  },
  ['vistrack', 'v1'] => {
    :servers => appservers,
    :port    => 30050
  }
}

template "nginx.conf" do
  variables(
    :services => services 
  )
  path "/etc/nginx/nginx.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

template "nginx.monit" do
  source "nginx.monit.erb"
  path "/etc/monit/conf.d/nginx.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
