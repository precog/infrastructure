name "cicommon"
description 'Continuous Integration Jenkins Common Stuff'
run_list "recipe[jenkins::dependencies]"
override_attributes({
  "rvm" => {
    "default_ruby" => "1.8.7",
    "group_users" => ["jenkins"]
  }
})

