name "Staging"
description "Staging server env"
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
  "deployer" => {
    "notified" => "operations@reportgrid.com",
    "server" => "http://stageapp02.reportgrid.com:29999/",
    "key" => "justanotherstagingkey",
    "mongodb" => "deployment-staging"
  }
})
