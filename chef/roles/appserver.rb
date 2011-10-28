name "appserver"
description 'ReportGrid application server role'
run_list "recipe[mongodb::mongos]", "recipe[reportgrid::appserver]", "recipe[haproxy]", "recipe[reportgrid::billing]", "recipe[reportgrid::ssl_proxy]"
