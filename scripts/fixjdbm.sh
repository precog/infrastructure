#!/bin/bash

[ "$#" -eq 1 ] || {
    echo "Usage: fixjdbm.sh <service name>"
    exit 1
}

STORAGE=$(grep -A1 storage /etc/precog/${1}.conf | tail -1 | cut -d '=' -f 2 | tr -d ' ')
CURRDIR=$(pwd | cut -c 1-$(echo -n "$STORAGE" | wc -c))

[ "$STORAGE" == "$CURRDIR" ] || {
    echo "Base dir of $1 is $STORAGE, but we seem to be elsewhere"
    exit 1
}

[ -f "byIdentity.d.0" ] || {
    echo "This script needs to be run from a jdbm/ directory for a projection!"
    exit 1
}

mkdir recovery
monit unmonitor $1
stop $1
cp byIdentity* recovery/
cd recovery
~ubuntu/scala-2.9.2/bin/scala -cp /usr/share/java/$1.jar ~ubuntu/fixjdbm.scala
cp fixed/* ../
start $1
monit monitor $1
