#!/bin/bash

if [ "$#" -ne "1" ]; then
  echo "Usage: `basename $0` <start|stop>"
  exit
fi

/etc/init.d/monit $1 && /etc/init.d/chef-client $1 && $1 deployer
