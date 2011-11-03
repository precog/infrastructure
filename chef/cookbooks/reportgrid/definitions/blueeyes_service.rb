define :blueeyes_service, :action=>:create, :port=>8100, :health_path=>nil, :memory => nil, :jar_file => nil do

  if params[:name].split('-').length == 2
    service_name, version = params[:name].split('-')
  else
    raise ArgumentError, "Name parameter not in the form of <name>-<version>: %s" % param
  end

  [:action].each do |param|
    raise ArgumentError, "Missing required parameter: %s" % param if params[param].nil?
  end

  # Set defaults for unspecified params
  params[:health_path] ||= '/blueeyes/services/%s/%s/health' % [service_name, version]
  params[:memory] ||= 4096
  params[:jar_file] ||= "#{params[:name]}.jar"

  case params[:action]
  when :delete

    file "#{params[:name]}.monit" do
      path "/etc/monit/conf.d/#{params[:name]}.monit"
      action :delete
      notifies :restart, resources(:service => "monit")
    end

    cron "#{params[:name]}-health" do
      user "reportgrid"
      action :delete
    end

    file "#{params[:name]}-health.sh" do
      path "/usr/local/bin/#{params[:name]}-health.sh"
      action :delete
    end

    service params[:name] do
      service_name params[:name]
      action :stop
    end

    file params[:name] do
      path "/etc/init.d/#{params[:name]}"
      action :delete
    end

    file "#{params[:name]}.init.conf" do
      path "/etc/init/#{params[:name]}.conf"
      action :delete
    end

    file "#{params[:name]}.default" do
      path "/etc/default/#{params[:name]}"
      action :delete
    end

    file "#{params[:name]}.conf" do
      path "/etc/reportgrid/#{params[:name]}.conf"
      action :delete
    end

    file params[:jar_file] do
      path "/usr/share/java/#{params[:jar_file]}"
      action :delete
    end

  else # on service creation, etc.

    execute "reload_upstart" do
      action :nothing
      command "initctl reload-configuration"
    end

    template "/etc/init/#{params[:name]}.conf" do
      variables(
        :service_name => service_name,
        :version      => version,
        :jar_file     => params[:jar_file]
      )
      source "blueeyes_service.init.conf.erb"
      mode "0644"
      notifies :run, "execute[reload_upstart]", :immediately
    end

    link params[:name] do
      to "/lib/init/upstart-job"
      target_file "/etc/init.d/#{params[:name]}"
    end

    service params[:name] do
      service_name params[:name]
      action :enable
    end

    #remote_file "#{params[:jar_file]}" do
    #  source "http://reportgrid.com.s3.amazonaws.com/deploy/production/#{params[:jar_file]}"
    #  path "/usr/share/java/#{params[:jar_file]}"
    #  mode "0644"
    #  notifies :restart, resources(:service => params[:name])
    #  action :create_if_missing
    #end

    template "/etc/reportgrid/#{params[:name]}.conf" do
      variables(
        :service_name => service_name,
        :version      => version,
        :port         => params[:port]
      )
      source "#{params[:name]}.conf.erb"
      mode "0644"
      notifies :restart, resources(:service => params[:name])
    end

    template "/etc/default/#{params[:name]}" do
      variables(
        :service_name => service_name,
        :version      => version,
        :port         => params[:port],
        :memory       => params[:memory]
      )
      source "blueeyes_service.default.erb"
      mode "0644"
      notifies :restart, resources(:service => params[:name])
    end

    template "/usr/local/bin/#{params[:name]}-health.sh" do
      variables(
        :health_path  => params[:health_path],
        :port         => params[:port]
      )
      source "blueeyes_service-health.sh.erb"
      mode "0755"
    end

    cookbook_file "#{params[:jar_file]}" do
      backup 20
      source "#{params[:jar_file]}"
      path "/usr/share/java/#{params[:jar_file]}"
      mode "0644"
    end

    cron "#{params[:name]}-health" do
      command "/usr/local/bin/#{params[:name]}-health.sh > /var/log/reportgrid/#{params[:name]}-health.log 2>&1"
      user "reportgrid"
    end

    template "/etc/monit/conf.d/#{params[:name]}.monit" do
      variables(
        :service_name => service_name,
        :version      => version,
        :port         => params[:port],
        :health_path  => params[:health_path]
      )
      source "blueeyes_service.monit.erb"
      mode "0644"
      notifies :restart, resources(:service => "monit")
    end
  end
end
