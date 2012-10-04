#
# Cookbook Name:: shardtmp
# Recipe:: client
#
# Copyright 2010-2012, Precog
#
# All rights reserved - Do Not Redistribute
#

directory "/srv/tmp" do
  owner "root"
  group "root"
  mode  "1777"
end

cron "clean sort spaces" do
  command "find /srv/tmp -name '13*-*' -mmin 10 | xargs rm -rf"
end
