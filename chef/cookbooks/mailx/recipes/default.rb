#
# Cookbook Name:: mailx
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
package "mailx" do
  if platform?("ubuntu", "debian") then
    package_name "bsd-mailx"
  end
end
