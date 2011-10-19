name "Test"
description "Test Environment"
cookbook_versions ({
  "ec2" => ">= 0.2.0"
})
default_attributes ({
  "postfix" => {
    "root_email" => "operations@reportgrid.com"
  }
})
