#
# Cookbook Name:: munin
# Recipe:: haproxy
#
# Copyright 2013, ReportGrid, Inc.
#

define :munin_haproxy, :backend => nil do

  if params[:backend].nil? then
    raise ArgumentError, "Missing haproxy backend name"
  end

  service_name = params[:service_name] ? params[:service_name] : node['munin']['service_name']

  execute "update-munin-plugins" do
    action :nothing
    command "munin-node-configure --shell | sh"
    notifies :restart, resources(:service => service_name)
  end

  backend = params[:backend]

  package 'socat'

  cookbook_file '/etc/munin/plugin-conf.d/haproxy.conf' do
    cookbook 'munin'
    source 'plugin-conf.d/haproxy.conf'
  end

  ["errors", "downtime", "sessions-by-servers"].each do |component|
    munin_plugin "haproxy-#{component}_" do
      plugin "haproxy-#{component}_#{backend}"
      create_file true
      notifies :run, "execute[update-munin-plugins]"
    end
  end
end
