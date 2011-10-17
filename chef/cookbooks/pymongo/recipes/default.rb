#
# Cookbook Name:: pymongo
# Recipe:: default
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# Make sure we *have* easy_install first
package "python-setuptools" do
  action :install
end

easy_install_package "pymongo" do
  version "2.0.1"
  action :install
end
