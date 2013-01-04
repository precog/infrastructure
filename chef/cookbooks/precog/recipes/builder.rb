#
# Cookbook Name:: precog
# Recipe:: builder
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_alias"
include_recipe "s3tools"

directory "#{node[:precog][:builder][:root]}" do
  recursive true
  owner "www-data"
  mode  "755"
end

cron "pull_s3_builder" do
  minute "*/5"
  command "mkdir -p /tmp/builderstage && s3cmd -c /root/.s3cfg --delete-removed --no-progress sync #{node[:precog][:builder][:s3url]} /tmp/builderstage 2>&1 >/dev/null | egrep -v 'is a directory|WARNING'; chmod -R g+w /tmp/builderstage && chgrp -R www-data /tmp/builderstage && rsync -aq --delete --delay-updates /tmp/builderstage/ #{node[:precog][:builder][:root]}"
end

web_app "builder" do
  server_name node['fqdn']
  server_aliases ["builder.reportgrid.com", "builder.precog.com", "devbuilder.precog.com"]
  docroot "#{node[:precog][:builder][:root]}/"
  template "builder.conf.erb"
end

