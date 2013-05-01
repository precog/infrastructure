name "cimaster"
description 'Continuous Integration Jenkins Master'
run_list "recipe[jenkins]", "role[cicommon]"
