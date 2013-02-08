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

mkdir recovery || {
    echo "Recovery directory exists already! Exiting!"
    exit 1
}

LOCKFILE=/var/lock/fixlock.${1}

(
    flock -n 9 || {
        echo "Could not acquire lockfile! Maybe it is stale?"
        ls -l $LOCKFILE
        exit 1
    }
    # ... commands executed under lock ...
    monit unmonitor $1
    stop $1
    cp byIdentity* recovery/
    cd recovery
    ~ubuntu/scala-2.9.2/bin/scala -cp /usr/share/java/$1.jar ~ubuntu/fixjdbm.scala
    cp fixed/* ../
    start $1
    monit monitor $1

    echo Removing lockfile
    rm $LOCKFILE
) 9> $LOCKFILE

# vim: et ts=4 sts=4 sw=4
