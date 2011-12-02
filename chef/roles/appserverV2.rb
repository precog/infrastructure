name "appserverV2"
description 'ReportGrid application server role v2'
run_list "recipe[mongodb::mongos]", "recipe[mongodb::mongos_fix]", "recipe[reportgrid::ssl_proxy]", "recipe[haproxy]", "recipe[rgdeployer]", "recipe[s3tools]", "recipe[reportgrid::appserver_log_backup]"
