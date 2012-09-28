name "port80web"
description 'Force apache to listen on port 80'
run_list "recipe[apache2]"
override_attributes "apache" => { "listen_ports" => [ "80" ] }
