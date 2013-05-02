name "cimaster"
description 'Continuous Integration Jenkins Master'
run_list "recipe[jenkins]", "role[cicommon]"
override_attributes({
  "jenkins" => {
    "rvm_users" => %w{jenkins dcsobral kris derek switzer erik daniel}
  }
})
