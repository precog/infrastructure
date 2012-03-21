#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2010-2012, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# Need to manually grab Java now that Canonical doesn't carry it
execute "manually package Java" do
command """
cd ~/
wget https://raw.github.com/flexiondotorg/oab-java6/master/oab-java6.sh -O oab-java6.sh
chmod +x oab-java6.sh
sudo ./oab-java6.sh
"""
  not_if "test -f ~/oab-java6.sh"
end

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
