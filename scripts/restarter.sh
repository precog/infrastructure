#!/bin/bash

if [ "$1" == "shard-v2" ]
then
    SRV=local_shard01
elif [ "$1" == "shard-v2-b" ]
then
    SRV=local_shard02
fi


LOCKFILE=/var/log/fixlock.${1}

(
    flock -n 9 || {
        echo "Could not acquire lockfile! Maybe it is stale?"
        ls -l $LOCKFILE
        exit 1
    }

    if [ -n "$SRV" ]
    then
        echo "disable server service_query/$SRV" | socat /var/lib/haproxy/stats stdio | grep -v '^$'
        while echo "show sess" | socat /var/run/haproxy.stat stdio | grep service_query | grep -q $SRV
        do
            echo "Waiting for sessions on $SRV to end"
            sleep 1
        done
    fi

    /sbin/restart --quiet $1

    if [ -n "$SRV" ]
    then
        echo "enable server service_query/$SRV" | socat /var/lib/haproxy/stats stdio | grep -v '^$'
    fi

    rm $LOCKFILE
) 9> $LOCKFILE
