name "Production"
description "Production server env"
cookbook_versions ({
  "mongodb" => "< 0.2.9" # holds back mongo journaling parameterization and others
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
  "apache" => {
    "listen_ports" => [ "20000" ]
  }
})
