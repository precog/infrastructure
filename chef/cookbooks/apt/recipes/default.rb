#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
# Copyright 2009, Bryan McLellan <btm@loftninjas.org>
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

# Run apt-get update to create the stamp file
execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  not_if do ::File.exists?('/var/lib/apt/periodic/update-success-stamp') end
end

# For other recipes to call to force an update
execute "apt-get update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

# Automatically remove packages that are no longer needed for dependencies
execute "apt-get autoremove" do
  command "apt-get -y autoremove"
  action :nothing
end

# Automatically remove .deb files for packages no longer on your system
execute "apt-get autoclean" do
  command "apt-get -y autoclean"
  action :nothing
end

# provides /var/lib/apt/periodic/update-success-stamp on apt-get update
package "update-notifier-common" do
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ::File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

%w{/var/cache/local /var/cache/local/preseeding}.each do |dirname|
  directory dirname do
    owner "root"
    group "root"
    mode  00755
    action :create
  end
end


# Local changes made from here on

execute "aptitude_update" do
  command "/usr/bin/aptitude update"
  action :nothing
end

template "sources.list" do
  source "sources.list.erb"
  path "/etc/apt/sources.list"
  mode "0644"
  notifies :run, resources(:execute => "aptitude_update"), :immediately
  ignore_failure true
end

package "unattended-upgrades" do
  package_name "unattended-upgrades"
end

template "10periodic" do
  source "10periodic.erb"
  path "/etc/apt/apt.conf.d/10periodic"
  mode "0644"
end

template "50unattended-upgrades" do
  source "50unattended-upgrades.erb"
  path "/etc/apt/apt.conf.d/50unattended-upgrades"
  mode "0644"
end

