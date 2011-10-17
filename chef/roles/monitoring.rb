name "monitoring"
description "Monitoring server"
run_list(
  "recipe[pymongo]", "recipe[nagios::server]"
)

default_attributes(
  "nagios" => {
    "server_auth_method" => "htauth"
  }
)
