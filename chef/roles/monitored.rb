name "monitored"
description "Monitoring client"
run_list(
  "recipe[munin::client]"
)
