name "quirrel-shard"
description "Quirrel shard member"
run_list "recipe[java]", "recipe[reportgrid::ssl_proxy]", "recipe[s3tools]"
