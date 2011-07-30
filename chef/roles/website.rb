name "website"
description 'ReportGrid website role'
run_list "recipe[reportgrid::website]", "recipe[reportgrid::apisite]"
