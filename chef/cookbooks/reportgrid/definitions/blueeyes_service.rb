define :blueeyes_service, :action=>:create, :port=>8100, :health_path=>nil do

  if params[:name].split('-').length == 2
    service_name, version = params[:name].split('-')
  else
    raise ArgumentError, "Name parameter not in the form of <name>-<version>: %s" % param
  end
  [:action].each do |param|
    raise ArgumentError, "Missing required parameter: %s" % param if params[param].nil?
  end

  params[:health_path] ||= '/blueeyes/services/%s/%s/health' % [service_name, version]

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

    file "#{params[:name]}.jar" do
      path "/usr/share/java/#{params[:name]}.jar"
      action :delete
    end

  else

    template "#{params[:name]}.init.conf" do
      variables(
        :service_name => service_name,
        :version      => version
      )
      source "blueeyes_service.init.conf.erb"
      path "/etc/init/#{params[:name]}.conf"
      mode "0644"
    end

    link params[:name] do
      to "/lib/init/upstart-job"
      target_file "/etc/init.d/#{params[:name]}"
    end

    service params[:name] do
      service_name params[:name]
      action :enable
    end

    #remote_file "#{params[:name]}.jar" do
    #  source "http://reportgrid.com.s3.amazonaws.com/deploy/production/#{params[:name]}.jar"
    #  path "/usr/share/java/#{params[:name]}.jar"
    #  mode "0644"
    #  notifies :restart, resources(:service => params[:name])
    #  action :create_if_missing
    #end

    template "#{params[:name]}.conf" do
      source "#{params[:name]}.conf.erb"
      path "/etc/reportgrid/#{params[:name]}.conf"
      mode "0644"
      notifies :restart, resources(:service => params[:name])
    end

    template "#{params[:name]}.default" do
      variables(
        :service_name => service_name,
        :version      => version,
        :port         => params[:port]
      )
      source "blueeyes_service.default.erb"
      path "/etc/default/#{params[:name]}"
      mode "0644"
      notifies :restart, resources(:service => params[:name])
    end

    cookbook_file "#{params[:name]}-health.sh" do
      source "#{params[:name]}-health.sh"
      path "/usr/local/bin/#{params[:name]}-health.sh"
      mode "0755"
    end

    cookbook_file "#{params[:name]}.jar" do
      backup 20
      source "#{params[:name]}.jar"
      path "/usr/share/java/#{params[:name]}.jar"
      mode "0644"
    end

    cron "#{params[:name]}-health" do
      command "/usr/local/bin/#{params[:name]}-health.sh > /var/log/reportgrid/#{params[:name]}-health.log 2>&1"
      user "reportgrid"
    end

    template "#{params[:name]}.monit" do
      variables(
        :service_name => service_name,
        :version      => version,
        :port         => params[:port],
        :health_path  => params[:health_path]
      )
      source "blueeyes_service.monit.erb"
      path "/etc/monit/conf.d/#{params[:name]}.monit"
      mode "0644"
      notifies :restart, resources(:service => "monit")
    end

  end
end
