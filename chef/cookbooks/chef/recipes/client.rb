#
# Cookbook Name:: chef
# Recipe:: client
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::opscode"

package "libshadow-ruby" do
  package_name "libshadow-ruby1.8"
end

service "chef-client" do
  service_name "chef-client"
  action :enable
end

template "client.rb" do
  source "client.rb.erb"
  path "/etc/chef/client.rb"
  mode "0644"
end

execute "clear-validation.pem" do
  command "> /etc/chef/validation.pem"
  only_if { File.file?('/etc/chef/validation.pem') && File.stat('/etc/chef/validation.pem').size > 0 }
end

template "chef-client.monit" do
  source "client.monit.erb"
  path "/etc/monit/conf.d/chef-client.monit"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end
