name "SpaceV2"
description "V2 Space Environment"
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
    },
    "builder" => {
      "s3url" => "s3://ops.reportgrid.com/builder-prod/"
    }
  },
  "deployer" => {
    "mongodb" => "deployment-devspace",
    "notified" => "operations@reportgrid.com",
    "server" => "http://devspace01.precog.com:29999/",
    "key" => "aV2devdeployIthink"
  }
})
