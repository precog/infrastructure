# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Copyright 2008-2009, Joe Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "varnish"

template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  if node['varnish']['vcl_cookbook']
    cookbook node['varnish']['vcl_cookbook']
  end
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

template node['varnish']['default'] do
  source "custom-default.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

template node['varnish']['ncsadefault'] do
  source "varnishncsa-default.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnishncsa]"
end

cookbook_file node['varnish']['ncsainit'] do
  source "varnishncsa-init"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, "service[varnishncsa]"
end

directory "/var/lib/varnish/#{node['varnish']['instance']}" do
  owner node['varnish']['user']
  group node['varnish']['group']
  mode "0751"
end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishncsa" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
