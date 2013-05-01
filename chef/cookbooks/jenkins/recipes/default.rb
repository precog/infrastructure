#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, ReportGrid, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt::jenkins"
package "jenkins"
