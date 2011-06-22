name "default"
description 'The default/base role for all nodes (i.e. all other roles are assumed to be "layered" on top of this one)'
run_list "recipe[rc-local]", "recipe[hosts]", "recipe[resolv]", "recipe[apt]", "recipe[ruby]", "recipe[python]",
         "recipe[monit]", "recipe[server_density]", "recipe[ec2]", "recipe[ec2::route53]", "recipe[rsyslog]", "recipe[ntp]",
         "recipe[mdadm]", "recipe[lvm]", "recipe[postfix]", "recipe[mailx]",
         "recipe[zsh]", "recipe[pam]", "recipe[sudo]", "recipe[openssh::client]", "recipe[openssh::server]",
         "recipe[git]", "recipe[zip]",
         "recipe[tmux]", "recipe[htop]", "recipe[iftop]", "recipe[nethogs]", "recipe[iotop]", "recipe[sysstat]", "recipe[chef::client]",
         "recipe[jazor]"
