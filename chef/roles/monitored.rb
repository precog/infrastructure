name "monitored"
description "Monitoring client"
run_list(
  "recipe[munin::client]", "recipe[munin::extraplugins]"
)
