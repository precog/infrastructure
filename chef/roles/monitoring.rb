name "monitoring"
description "Monitoring server"
run_list(
  "recipe[pymongo]", "recipe[nagios::server]", "recipe[munin::server]", "recipe[munin::client]",
  "recipe[nagios::pagerduty]"
)

default_attributes(
  "nagios" => {
    "server_auth_method" => "htauth",
    'pagerduty_key' => '9966a8ce29fc472bb0c46682dcb61752'
  },
  "munin" => {
    'sysadmin_email' => 'operations@reportgrid.com',
    'server_auth_method' => 'htauth',
    'max_graph_jobs' => 12
  }
)
override_attributes "apache" => { "listen_ports" => [ "80", "443" ] }
