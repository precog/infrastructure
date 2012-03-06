name "minimal"
description 'The default/base role for all nodes (i.e. all other roles are assumed to be "layered" on top of this one)'
run_list "recipe[ubuntu_user]", "recipe[sudo]", "recipe[rc-local]", "recipe[hosts]",
         "recipe[python]", "recipe[monit]", "recipe[ec2::route53]",
         "recipe[mailx]"
