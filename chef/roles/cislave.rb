name "cislave"
description 'Continuous Integration Jenkins Slave'
run_list "role[cicommon]"
override_attributes({
  "jenkins" => {
    "rvm_users" => %w{jenkins dcsobral derek}
  }
})
