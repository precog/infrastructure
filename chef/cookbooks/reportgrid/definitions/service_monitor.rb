define :service_monitor do
  
  if params[:name].split('-').length == 2
    service_name, version = params[:name].split('-')
  else
    raise ArgumentError, "Name parameter not in the form of <name>-<version>: %s" % param
  end

  execute "update-munin-plugins" do
    action :nothing
    command "munin-node-configure --shell | sh"
    notifies :restart, "service[munin-node]"
  end

  template "/usr/share/munin/plugins/#{params[:name]}_timing" do
    variables(
      :service_name => service_name,
      :service_version => version
    )
    source "munin_service_timing.erb"
    mode "755"
    notifies :run, "execute[update-munin-plugins]"
  end

  template "/usr/share/munin/plugins/#{params[:name]}_rates" do
    variables(
      :service_name => service_name,
      :service_version => version
    )
    source "munin_service_rates.erb"
    mode "755"
    notifies :run, "execute[update-munin-plugins]"
  end
  
end
