name "Production"
description "Production server env"
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
