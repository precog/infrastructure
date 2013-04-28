#
# Cookbook Name:: munin
# Recipe:: haproxy
#
# Copyright 2013, ReportGrid, Inc.
#

package 'socat'

["errors", "downtime", "sessions-by-servers"].each do |component|
  munin_plugin "haproxy-#{component}" do
    create_file true
  end
end
