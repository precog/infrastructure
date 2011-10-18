name "base"
description 'The default/base role for all nodes (i.e. all other roles are assumed to be "layered" on top of this one)'
#run_list "recipe[resolv]", "recipe[apt]",
#         "recipe[monit]", "recipe[server_density]", "recipe[ec2]", "recipe[ec2::route53]", "recipe[rsyslog]", "recipe[ntp]",
#         "recipe[mdadm]", "recipe[lvm]",
#         "recipe[zsh]", "recipe[pam]", "recipe[sudo]", "recipe[openssh::client]", "recipe[openssh::server]", "recipe[openssh::roundhousesupport]",
#         "recipe[git]", "recipe[zip]",
#         "recipe[tmux]", "recipe[htop]", "recipe[iftop]", "recipe[nethogs]", "recipe[iotop]", "recipe[sysstat]", "recipe[chef::client]",
#         "recipe[jazor]"

run_list "recipe[rc-local]", "recipe[hosts]", "recipe[at]", "recipe[ruby]",
         "recipe[python]", "recipe[monit]", "recipe[ec2::route53]", "recipe[postfix]",
         "recipe[mailx]", "recipe[munin::client]", "recipe[apt]", "recipe[chef::client]"
