#
# Cookbook Name:: reportgrid
# Recipe:: visualization
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "reportgrid::baseenv"
include_recipe "reportgrid::source"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "phantomjs"

## Grab wkhtmltopdf from S3
#execute "pull-wkhtmltopdf" do
#  command "s3cmd sync --no-progress --no-delete-removed s3://ops.reportgrid.com/bin/wkhtmltopdf-amd64 /usr/local/bin/"
#end

# Ugly hack to deploy the built binary for wkhtmltopdf
cookbook_file "/opt/reportgrid/wkhtmltopdf-rc.tgz" do
  owner "root"
  group "root"
  mode "755"
end

execute "unpack_built_wkhtmltopdf" do
  only_if "test ! -x /bin/wkhtmltopdf -o /opt/reportgrid/wkhtmltopdf-rc.tgz -nt /bin/wkhtmltopdf"
  user "root"
  command "tar xvzf /opt/reportgrid/wkhtmltopdf-rc.tgz && touch /bin/wkhtmltopdf"
end

cookbook_file "/bin/wkhtmltoimage" do
  owner "root"
  group "root"
  mode "755"
end
# End ugly hack

directory "visualization_root" do
  path node[:reportgrid][:visualization][:root]
  recursive true
  owner "reportgrid"
  group "reportgrid"
  mode "755"
end

cachedir = "#{node[:reportgrid][:visualization][:root]}/staticrenderer/cache" 
tmpdir = "#{node[:reportgrid][:visualization][:root]}/tmp" 

directory cachedir do
  recursive true
  owner "www-data"
  mode "755"
end

directory tmpdir do
  recursive true
  owner "www-data"
  mode "755"
end

cron "purge_visualization_cache" do
  minute "55"
  # Purge items older than 30 days
  # TODO: parameterize this
  command "find #{cachedir} -ctime +1 -type f -delete > /dev/null"
end

# Pull from s3
cron "pull_s3_vis" do
  minute "*/3"
  command "mkdir -p /tmp/visualizationstage && s3cmd -c /root/.s3cfg --delete-removed --no-progress sync #{node[:reportgrid][:visualization][:s3url]} /tmp/visualizationstage 2>&1 >/dev/null | egrep -v 'is a directory|WARNING'; chmod -R g+w /tmp/visualizationstage && chgrp -R www-data /tmp/visualizationstage && rsync -aq --delete --delay-updates /tmp/visualizationstage/services #{node[:reportgrid][:visualization][:root]}"
end

web_app "visualization" do
#  server_name "api.reportgrid.com"
#  server_aliases [node['fqdn']]
  server_name node['fqdn']
  server_aliases ["api.reportgrid.com", "devapi.reportgrid.com"]
  docroot "#{node[:reportgrid][:visualization][:root]}/services"
  template "visualization.conf.erb"
end

# To allow for mongo PHP driver install:
package "php5-dev"
package "php-pear"

execute "install_php_mongo" do
  not_if "pecl list | grep mongo"
  user "root"
  command "pecl install mongo"
end

cookbook_file "/etc/php5/conf.d/mongo_php.ini" do
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[apache2]"
end
