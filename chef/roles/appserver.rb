name "appserver"
description 'ReportGrid application server role'
run_list "recipe[mongodb::mongos]", "recipe[reportgrid::appserver]", "recipe[reportgrid::billing]", "recipe[reportgrid::vistrack]", "recipe[reportgrid::ssl_proxy]", "recipe[haproxy]"
