#
# Cookbook Name:: reportgrid
# Recipe:: digester
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init/digester-v1.conf" do
  variables(
    :version => "v1",
    :jar_file => "analytics-v1.jar"
  )
  source "digester.init.conf.erb"
  mode "0644"
end

link params[:name] do
  to "/lib/init/upstart-job"
  target_file "/etc/init.d/digester-v1"
end

service "digester-v1" do
  service_name "digester-v1"
  action [:enable, :start]
end
