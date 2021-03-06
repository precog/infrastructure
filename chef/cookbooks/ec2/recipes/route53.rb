#
# Cookbook Name:: ec2
# Recipe:: route53
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# This is required for the gem to work
package "libopenssl-ruby1.8"

# FIXME: http://tickets.opscode.com/browse/CHEF-1669
gem_package "route53" do
  package_name "route53"
end

execute "route53.sh" do
  command "/etc/rc.local.d/route53.sh"
  action :nothing
  only_if "test -f /etc/rc.local.d/route53.sh"
end

template "route53" do
  source "route53.erb"
  path "/root/.route53"
  mode "0600"
  notifies :run, "execute[route53.sh]"
end

template "route53.sh" do
  source "route53.sh.erb"
  path "/etc/rc.local.d/route53.sh"
  mode "755"
  notifies :run, "execute[route53.sh]"
end

template "/etc/logrotate.d/route53" do
  source "route53.logrotate.erb"
  mode "644"
end

# FIXME: how do we monitor this file?
#template "route53.monit" do
#  source "route53.monit.erb"
#  path "/etc/monit/conf.d/route53.monit"
#  mode "0644"
#  notifies :restart, resources(:service => "monit")
#end
