name "Productionv2"
description "Production server env"
cookbook_versions ({
  "apt" => "0.1"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  },
                      "apache" => {
                        "listen_ports" => [ "20000" ]
                      }
})
