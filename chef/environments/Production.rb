name "Production"
description "Production server env"
cookbook_versions ({
  "ec2" => "0.1.0",
  "hosts" => "0.1",
  "apt" => "0.1",
  "chef" => "0.1"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  }
})
