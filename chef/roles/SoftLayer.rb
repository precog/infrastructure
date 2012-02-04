name "SoftLayer"
description "Set SoftLayer-specific attributes"
override_attributes({
  "monit" => {
    "extra_filesystems" => ["/dev/sda1", "/dev/sdb1"]
  }
})
