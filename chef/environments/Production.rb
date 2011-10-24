name "Production"
description "Production server env"
cookbook_versions ({
  "apt" => "0.1",
  "reportgrid" => "0.2.1",
  "mongodb" => "0.1",
  "hosts" => "0.2",
  "ec2" => "0.3"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
                      "apache" => {
                        "listen_ports" => [ "20000" ]
                      }
})
