name "appserverV2"
description 'ReportGrid application server role v2'
run_list "recipe[mongodb::mongos]", "recipe[reportgrid::ssl_proxy]", "recipe[haproxy]", "recipe[rgdeployer]", "recipe[s3tools]"
