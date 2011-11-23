name "QA"
description "QA Environment"
cookbook_versions ({
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
  "apache" => {
    "listen_ports" => [ "20000" ]
  }
})
override_attributes ({
  "mongodb" => {
    "mongos_enabled" => "no"
  },
  "deployer" => {
    "notified" => "derek@reportgrid.com",
    "server" => "http://devci01.reportgrid.com:29999/",
    "key" => "fd9erer9345vn911az0",
    "agent_options" => "debug: true"
  }
})
