default[:monit][:startup] = "1"
default[:monit][:alert_recipients] = [ "root@localhost" ]

# FIXME: http://tickets.opscode.com/browse/CHEF-1688
set_unless[:environment] = "production"

case environment
when "production"
    #default[:monit][:critical_alert_recipients] = [ "2039804274@vtext.com" ]
    default[:monit][:critical_alert_recipients] = [ ]
else
    default[:monit][:critical_alert_recipients] = [ ]
end
