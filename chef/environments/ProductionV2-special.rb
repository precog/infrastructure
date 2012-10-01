name "ProductionV2-Special"
description "ProductionV2 special server env"
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
      "s3url" => "s3://ops.reportgrid.com/viz-prod/"
    }
  },
  "precog" => {
    "ide" => {
      "s3url" => "s3://ops.reportgrid.com/ide-prod/"
    }
  },
  "deployer" => {
    "mongodb" => "deployment-prodv2-special",
    "notified" => "operations@reportgrid.com",
    "server" => "http://nebula.precog.com:29999/",
    "key" => "aV2prodspecdeployIthink"
  }
})

