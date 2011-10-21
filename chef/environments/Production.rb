name "Production"
description "Production server env"
cookbook_versions ({
  "apt" => "0.1",
  "chef" => "0.1",
  "reportgrid" => "0.1",
  "mongodb" => "0.1"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
                      "apache" => {
                        "listen_ports" => [ "20000" ]
                      }
})
