name "quirrel-shardV2"
description "Quirrel shard member"
run_list "recipe[rgdeployer]", "recipe[precog::utils]", "recipe[java]", "recipe[haproxyV2]", "recipe[s3tools]", "recipe[precog::ide]", "recipe[precog::shardtmp]", "recipe[reportgrid::builder]", "recipe[precog::raptor]"
override_attributes "apache" => { "listen_ports" => [ "20000" ] }
