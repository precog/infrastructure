#
# Cookbook Name:: monodev
# Recipe:: default
#
# Copyright 2013, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

if platform_family?("debian")
  package "doxygen"
  package "mono-devel"
  package "mono-xbuild"
  package "monodoc-base"
  package "nunit"
  package "nunit-console"
end

execute "update_monocerts" do
  user "root"
  command "mozroots --import --machine --sync"
end


# For some reason the machine store doesn't always seem to be used, so we explicitly run for jenkins
execute "update_monocerts_jenkins" do
  user "jenkins"
  command "mozroots --import --sync --ask-remove"
end
