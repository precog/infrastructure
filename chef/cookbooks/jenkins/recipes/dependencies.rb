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

rvm_ruby "1.8.7"
rvm_ruby "1.9.3"
rvm_gemset "1.8.7@client"
rvm_gemset "1.9.3@client"

group "rvm" do
  members %w{jenkins dcsobral kris derek switzer erik daniel}
end

