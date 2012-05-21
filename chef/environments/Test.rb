name "Test"
description "Test Environment"
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
  "reportgrid" => {
    "tokens" => {
      "test" => {
        "rollup" => "5"
      }
    },
    "visualization" => {
      "s3url" => "s3://ops.reportgrid.com/viz-dev/"
    }
  },
  "mongodb" => {
    "mongos_enabled" => "yes",
    "config_servers" => [
      "devmongo-config01.reportgrid.com:27019",
      "devmongo-config02.reportgrid.com:27019",
      "devmongo-config03.reportgrid.com:27019"
    ]
  },
  "deployer" => {
    "notified" => "derek@reportgrid.com",
    "server" => "http://devmongo04.reportgrid.com:29999/",
    "key" => "feedfacedeadbeef",
    "agent_options" => "debug: true"
  }
})
