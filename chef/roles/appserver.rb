name "appserver"
description 'ReportGrid application server role'
run_list "recipe[reportgrid::appserver]", "recipe[haproxy]"
