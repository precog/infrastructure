name "quirrel-shardV2"
description "Quirrel shard member"
run_list "recipe[rgdeployer]", "recipe[precog::utils]", "recipe[java]", "recipe[haproxyV2]", "recipe[precog::ssl_proxy]", "recipe[s3tools]", "recipe[precog::ide]", "recipe[precog::shardtmp]"
