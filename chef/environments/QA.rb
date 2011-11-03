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
  "reportgrid" => {
    "eventsdb" => {
      "hosts" => [ "localhost:27017" ]
    },
    "indexdb" => {
      "hosts" => [ "localhost:27017" ]
    },
    "mongo" => {
      "hosts" => [ "localhost:27017" ]
    }
  }
})
