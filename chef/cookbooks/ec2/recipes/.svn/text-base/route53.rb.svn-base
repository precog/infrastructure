#
# Cookbook Name:: ec2
# Recipe:: route53
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# FIXME: http://tickets.opscode.com/browse/CHEF-1669
gem_package "route53" do
  package_name "route53"
end

template "route53" do
  source "route53.erb"
  path "/root/.route53"
  mode "0600"
end

template "route53.sh" do
  source "route53.sh.erb"
  path "/etc/rc.local.d/route53.sh"
  mode "755"
end

#execute "route53.sh" do
#  command "/etc/rc.local.d/route53.sh"
#end

# FIXME: how do we monitor this file?
#template "route53.monit" do
#  source "route53.monit.erb"
#  path "/etc/monit/conf.d/route53.monit"
#  mode "0644"
#  notifies :restart, resources(:service => "monit")
#end
