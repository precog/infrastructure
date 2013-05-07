name "cidep"
description 'Continuous Integration Dependencies (jenkins not included)'
run_list "recipe[monodev]", "recipe[nodejs]", "recipe[wintersmith]"
