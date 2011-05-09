#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
execute "update-java-alternatives" do
  command "/usr/sbin/update-java-alternatives --set java-6-sun"
  ignore_failure true
  action :nothing
end

package "sun-java6-jdk" do
  package_name "sun-java6-jdk"
  response_file "java.seed"
  options '-o Dpkg::Options::="--force-confold"'
  notifies :run, resources(:execute => "update-java-alternatives"), :immediately
  ignore_failure true
end

cookbook_file "java.security" do
  source "java.security"
  path "/etc/java-6-sun/security/java.security"
  mode "644"
end
