#
# Cookbook Name:: apt
# Recipe:: jenkins
#
# Copyright 2013, ReportGrid
#
# All rights reserved - Do Not Redistribute
#
apt_repository "jenkins" do
  uri "http://pkg.jenkins-ci.org/debian/"
  distribution "binary/"
  key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
end

