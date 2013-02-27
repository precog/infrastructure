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
    echo "Recovery directory exists -- trying to move old directories"
    set -e
    if [ -d recovery.0 ]
    then
        LASTFILE=$(ls -1d recovery.* | sort -t '.' -k 2 -n | tail -1)
        LASTVER=${LASTFILE##*.}
        for ver in $(seq $LASTVER -1 0)
        do
            mv recovery.$ver recovery.$(($ver + 1))
        done
    else
        LASTVER=-1
    fi
    mv recovery recovery.0
    mkdir recovery
    echo "Moved old diretories. There are now $(($LASTVER + 3)) recovery directories"
    set +e
}

LOCKFILE=/var/lock/fixlock.${1}

(
    flock -n 9 || {
        echo "Could not acquire lockfile! Maybe it is stale?"
        ls -l $LOCKFILE
        exit 1
    }
    # ... commands executed under lock ...
    monit -g $1 unmonitor
    stop $1
    cp byIdentity* recovery/
    cd recovery
    ~ubuntu/scala-2.9.2/bin/scala -cp /usr/share/java/$1.jar ~ubuntu/fixjdbm.scala
    cp fixed/* ../
    start $1
    monit -g $1 monitor

    echo Removing lockfile
    rm $LOCKFILE
) 9> $LOCKFILE

# vim: et ts=4 sts=4 sw=4
