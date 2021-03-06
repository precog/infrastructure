#
# Cookbook Name:: precog
# Recipe:: staticsite
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#
include_recipe "nginx::repo"
include_recipe "nginx"
include_recipe "nginx::rrd"
include_recipe "precog::nginxcerts"
include_recipe "nodejs"

directory '/var/cache/nginx/proxy_cache' do
  owner 'www-data'
  group 'root'
  mode "700"
  recursive true
end

directory '/var/www/precogsite' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/precogsite/releases' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/precogsite/shared' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/nodejs' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/nodejs/releases' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/www/nodejs/shared' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

directory '/var/log/nodejs' do
  owner 'www-data'
  group 'www-data'
  mode "775"
end

directory '/var/www/precogsite/shared/apidocs' do
  owner "ubuntu"
  group "www-data"
  mode  "2775"
end

%w{java dotnet js python ruby}.each do |language|
  directory "/var/www/precogsite/shared/apidocs/#{language}" do
    owner "ubuntu"
    group "www-data"
    mode  "2775"
  end
end

directory '/etc/nginx/redirects.d' do
  owner 'root'
  group 'root'
  mode '755'
end

link '/etc/nginx/redirects.d/staticsite.conf' do
  to '/var/www/precogsite/current/redirects.conf'
end

template "#{node['nginx']['dir']}/sites-available/staticsite" do
  source "staticsite.erb"
  owner "root"
  group "root"
  mode '644'
  notifies :reload, 'service[nginx]'
end

nginx_site 'staticsite' do
  enable true
end

template "#{node['nginx']['dir']}/sites-available/staticsite-ssl" do
  source "staticsitessl.erb"
  owner "root"
  group "root"
  mode '644'
  notifies :reload, 'service[nginx]'
end

nginx_site 'staticsite-ssl' do
  enable true
end

cookbook_file '/etc/init/nodejs.conf' do
  owner 'root'
  group 'root'
  mode '644'
end

munin_plugin "nginx_combined_" do
  plugin "nginx_combined_127.0.0.1"
  create_file true
end

munin_plugin "nginx_memory" do
  create_file true
end

cookbook_file "/etc/monit/conf.d/nodejs.monit" do
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

