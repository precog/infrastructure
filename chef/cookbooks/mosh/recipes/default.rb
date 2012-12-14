#
# Cookbook Name:: mosh
# Recipe:: default
#
# Copyright 2012, Precog
#
# All rights reserved - Do Not Redistribute
#

add_apt_repo do
  url "ppa:keithw/mosh"
end

package "mosh"
