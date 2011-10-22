#
# Cookbook Name:: munin
# Recipe:: extraplugins
#
# Copyright 2011, ReportGrid, Inc.
#

["btree", "conn", "lock", "mem", "ops"].each do |component|
  munin_plugin "mongo_#{component}" do
    create_file true
  end
end
