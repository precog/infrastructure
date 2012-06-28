#
# Cookbook Name:: precog
# Recipe:: ide
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_alias"
include_recipe "s3tools"

directory "/var/www/ide" do
  recursive true
  owner "www-data"
  mode  "755"
end

cron "pull_s3_ide" do
  minute "*/5"
  command "mkdir -p /tmp/idestage && s3cmd -c /root/.s3cfg --delete-removed --no-progress sync #{node[:precog][:ide][:s3url]} /tmp/idestage 2>&1 >/dev/null | egrep -v 'is a directory|WARNING'; chmod -R g+w /tmp/idestage && chgrp -R www-data /tmp/idestage && rsync -aq --delete --delay-updates /tmp/idestage/ #{node[:precog][:ide][:root]}"
end

web_app "ide" do
  server_name node['fqdn']
  server_aliases ["ide.precog.com", "devide.precog.com", "api.precog.com", "devapi.precog.com"]
  docroot "#{node[:precog][:ide][:root]}/"
  template "ide.conf.erb"
end


