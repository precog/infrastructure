#!/bin/bash

#
# A simple script to force a thread dump for a given service
#

if [[ $# != 1 ]]; then
    echo "Usage: `basename $0` <service name>"
    exit
fi

for pid in `pidof /usr/bin/java`; do 
    if ps -f -p $pid | grep $1 > /dev/null; then 
	kill -QUIT $pid 
    fi
done