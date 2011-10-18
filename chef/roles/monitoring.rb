name "monitoring"
description "Monitoring server"
run_list(
  "recipe[pymongo]", "recipe[nagios::server]", "recipe[munin::server]", "recipe[munin::client]"
)

default_attributes(
  "nagios" => {
    "server_auth_method" => "htauth"
  }
)
