#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2010-2012, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# Need to manually grab Java now that Canonical doesn't carry it
#execute "manually package/update Java" do
#command """
#cd ~/
#wget https://raw.github.com/dchenbecker/oab-java6/master/oab-java6.sh -O oab-java6.sh
#chmod +x oab-java6.sh
#sudo ./oab-java6.sh -s
#"""
#end
#
#execute "update-java-alternatives" do
#  command "/usr/sbin/update-java-alternatives --set java-6-sun"
#  ignore_failure true
#  action :nothing
#end
#
#package "sun-java6-jdk" do
#  package_name "sun-java6-jdk"
#  response_file "java.seed"
#  options '-o Dpkg::Options::="--force-confold"'
#  notifies :run, resources(:execute => "update-java-alternatives"), :immediately
#  ignore_failure true
#end
#
#cookbook_file "java.security" do
#  source "java.security"
#  path "/etc/java-6-sun/security/java.security"
#  mode "644"
#end

#package "java-common"
#
#["sun-java6-bin_6.31-2~lucid1_amd64.deb", "sun-java6-fonts_6.31-2~lucid1_all.deb", "sun-java6-jdk_6.31-2~lucid1_amd64.deb", "sun-java6-jre_6.31-2~lucid1_all.deb"].each { |filename|
#  cookbook_file "/tmp/#{filename}"
#}
#
#execute "install_java" do
#  not_if "dpkg -l 'sun-java6*' | grep '^ii'"
#  command "dpkg -i /tmp/sun-java6*"
#  ignore_failure true
#end

# Use openjdk to keep things simple
package "default-jdk"

package "sun-java6-jre" do
  action :purge
end

package "sun-java6-jdk" do
  action :purge
end
