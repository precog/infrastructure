#
# Cookbook Name:: precog
# Recipe:: baseenv
#
# Copyright 2011, Precog
#
# All rights reserved - Do Not Redistribute
#
user "precog" do
  system true
  comment "Precog service account"
  home "/var/log/precog"
  shell "/bin/false"
  not_if "/usr/bin/id precog" # FIXME: http://tickets.opscode.com/browse/CHEF-1701
end

directory "precog_conf" do
  path "/etc/precog"
  mode '755'
end

directory "precog_data" do 
  path "/opt/precog"
  mode '755'
end

directory "precog_logs" do
  path "/var/log/precog"
  owner 'precog'
  group 'precog'
  mode '755'
end
