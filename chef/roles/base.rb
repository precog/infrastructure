name "base"
description 'The default/base role for all nodes (i.e. all other roles are assumed to be "layered" on top of this one)'
#run_list "recipe[resolv]",
#         "recipe[monit]", "recipe[server_density]", "recipe[ec2]", "recipe[rsyslog]", 
#         "recipe[mdadm]", "recipe[lvm]",
#         "recipe[zsh]", "recipe[pam]", "recipe[openssh::client]", "recipe[openssh::server]",
#         "recipe[git]", "recipe[zip]",
#         "recipe[tmux]", "recipe[iftop]", "recipe[nethogs]", "recipe[sysstat]",
#         "recipe[jazor]"

run_list "recipe[ubuntu_user]", "recipe[sudo]", "recipe[rc-local]", "recipe[hosts]", "recipe[at]", "recipe[ruby]",
         "recipe[python]", "recipe[monit]", "recipe[ec2::route53]", "recipe[postfix]", "recipe[rsyslog]",
         "recipe[mailx]", "recipe[munin::client]", "recipe[apt]", "recipe[chef::client]", "recipe[ntp]",
         "recipe[htop]", "recipe[iotop]", "recipe[sysstat]"
