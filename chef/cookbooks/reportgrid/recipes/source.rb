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

cookbook_file "id_github_website" do
  source "id_github_website"
  path "/root/.ssh/id_github_website"
  mode "600"
end

cookbook_file "id_github_website.pub" do
  source "id_github_website.pub"
  path "/root/.ssh/id_github_website.pub"
  mode "644"
end

cookbook_file "id_github_apisite" do
  source "id_github_apisite"
  path "/root/.ssh/id_github_apisite"
  mode "600"
end

cookbook_file "id_github_apisite.pub" do
  source "id_github_apisite.pub"
  path "/root/.ssh/id_github_apisite.pub"
  mode "644"
end
