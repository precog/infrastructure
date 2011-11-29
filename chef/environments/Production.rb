name "Production"
description "Production server env"
cookbook_versions ({
  "reportgrid" => "< 0.2.12"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
  "apache" => {
    "listen_ports" => [ "20000" ]
  }
})
