name "ProductionV2"
description "ProductionV2 server env"
cookbook_versions ({
  "haproxyV2" => "< 0.1.0" # Disable use of this recipe
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
      "s3url" => "s3://ops.reportgrid.com/viz-prodv2/"
    }
  },
  "precog" => {
    "ide" => {
      "s3url" => "s3://ops.reportgrid.com/ide-prodv2/"
    }
  },
  "deployer" => {
    "mongodb" => "deployment-prodv2",
    "notified" => "operations@reportgrid.com",
    "server" => "http://qclus-demo01.reportgrid.com:29999/",
    "key" => "aV2proddeployIthink"
  }
})

