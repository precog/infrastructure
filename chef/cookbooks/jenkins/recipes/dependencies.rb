#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "monodev"
include_recipe "nodejs"
include_recipe "wintersmith"
include_recipe "rvm::system_install"
include_recipe "python"

rvm_ruby "1.8.7"
rvm_ruby "1.9.3"
rvm_gemset "1.8.7@client"
rvm_gemset "1.9.3@client"

group "rvm" do
  members node['jenkins']['rvm_users']
end

package 'yui-compressor'
package 'optipng'
package 'jpegoptim'

%w{pip pytest Fabric Pygments ohconvert Sphinx}.each do |package|
  python_pip package do
    action :install
  end
end

