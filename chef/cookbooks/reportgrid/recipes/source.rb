#
# Cookbook Name:: reportgrid
# Recipe:: source
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
include_recipe "git"

directory "source_root" do
  path node[:reportgrid][:source][:root]
  mode '755'
end

cookbook_file "ssh_config" do
  source "ssh_config"
  path "/root/.ssh/config"
  mode "600"
end

cookbook_file "id_github" do
  source "id_github"
  path "/root/.ssh/id_github"
  mode "600"
end

cookbook_file "id_github.pub" do
  source "id_github.pub"
  path "/root/.ssh/id_github.pub"
  mode "644"
end
