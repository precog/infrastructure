#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "irb" do
  package_name "irb"
end

package "ruby-dev" do
  package_name "ruby-dev"
end

package "rubygems" do
  package_name "rake"
end

gem_package "rubygems-update" do
  package_name "rubygems-update"
end

#package "rake" do
#  package_name "rake"
#end

#gem_package "lockfile" do
#  package_name "lockfile"
#end

#gem_package "log4r" do
#  package_name "log4r"
#end

template "rubygems.sh.profile" do
  source "rubygems.sh.profile.erb"
  path "/etc/profile.d/rubygems.sh"
  mode "0755"
end
