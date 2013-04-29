name "precogstaticsite"
description 'Settings for precog website nodes serving static site'
run_list "recipe[nginx::repo]", "recipe[nginx]", "recipe[precog::staticsite]", "recipe[precog::blogredirect]", "recipe[precog::reportgridredirect]"
override_attributes 'nginx' => { 'default_site_enabled' => false, 'authorized_ips' => ['50.57.147.129', '127.0.0.1']  }
