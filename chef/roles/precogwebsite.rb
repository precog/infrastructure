name "precogwebsite"
description 'Settings for precog website nodes'
run_list "recipe[apache2]"
override_attributes "apache" => { "listen_ports" => [ "80" ] }, "extra_hosts" => [ 
  "10.38.35.132\twebdb.precog.com web1-internal.precog.com",
  "10.38.35.133\tweb2-internal.precog.com"
]
