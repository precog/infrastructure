name "Production"
description "Production server env"
cookbook_versions ({
  "java" => "< 0.4"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
  "apache" => {
    "listen_ports" => [ "20000" ]
  }
})
