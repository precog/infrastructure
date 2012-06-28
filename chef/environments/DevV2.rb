name "DevV2"
description "V2 Dev Environment"
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
  "precog" => {
    "ide" => {
      "s3url" => "s3://ops.reportgrid.com/ide-dev/"
    }
  },
  "deployer" => {
    "mongodb" => "deployment-qclusdev",
    "notified" => "operations@reportgrid.com",
    "server" => "http://devqclus02.reportgrid.com:29999/",
    "key" => "aV2devdeployIthink"
  }
})
