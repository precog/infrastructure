name "appserverV2"
description 'ReportGrid application server role v2'
run_list "recipe[java]", "recipe[mongodb::mongos]", "recipe[reportgrid::ssl_proxy]", "recipe[haproxy]", "recipe[rgdeployer]", "recipe[s3tools]", "recipe[reportgrid::appserver_log_backup]", "recipe[reportgrid::utils]","recipe[precog::precog-io-redirect]", "recipe[nginxReportGrid]"
