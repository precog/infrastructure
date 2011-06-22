name "appserver"
description 'ReportGrid application server role'
run_list "recipe[mongodb::mongos]", "recipe[reportgrid::appserver]", "recipe[haproxy]"
