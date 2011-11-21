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
    "eventsdb" => {
      "hosts" => [ "devmongo01.reportgrid.com:27017" ]
    },
    "indexdb" => {
      "hosts" => [ "devmongo01.reportgrid.com:27017" ]
    },
    "mongo" => {
      "hosts" => [ "devmongo01.reportgrid.com:27017" ]
    },
    "tokens" => {
      "test" => {
        "rollup" => "5"
      }
    }                    
  },
  "mongodb" => {
    "mongos_enabled" => "no"
  },
  "deployer" => {
    "notified" => "derek@reportgrid.com",
    "server" => "http://devmongo01.reportgrid.com:29999/",
    "key" => "feedfacedeadbeef",
    "agent_options" => "debug: true"
  }
})
