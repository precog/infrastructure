name "precogwebsitevarnish"
description 'Settings for precog website nodes using varnish'
run_list "recipe[apache2]"
run_list "recipe[varnish]"
override_attributes "apache" => { "listen_ports" => [ "8080", "443" ] }, "extra_hosts" => [ 
  "10.38.35.132\twebdb.precog.com web1-internal.precog.com",
  "10.38.35.133\tweb2-internal.precog.com"
]
