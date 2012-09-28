#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rc-local"

execute "iptables.sh" do
  command "/etc/rc.local.d/iptables.sh"
  action :run
  only_if "test -f /etc/rc.local.d/iptables.sh"
end

execute "iptables-local.sh" do
  command "/etc/rc.local.d/iptables-local.sh"
  action :run
  only_if "test -f /etc/rc.local.d/iptables-local.sh"
end

template "/etc/rc.local.d/iptables.sh" do
  variables(:rgservers => search(:node, "*:*"))
  mode "755"
  notifies :run, resources(:execute => "iptables.sh", :execute => "iptables-local.sh")
end

  
