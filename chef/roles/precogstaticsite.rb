name "precogstaticsite"
description 'Settings for precog website nodes serving static site'
run_list "recipe[nginx::repo]", "recipe[nginx]", "recipe[precog::staticsite]"
override_attributes 'nginx' => { 'default_site_enabled' => false }
