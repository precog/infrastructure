#!/bin/bash

LOCKFILE=/var/log/fixlock.${1}

(
    flock -n 9 || {
        echo "Could not acquire lockfile! Maybe it is stale?"
        ls -l $LOCKFILE
        exit 1
    }

    /sbin/restart --quiet $1

    rm $LOCKFILE
) 9> $LOCKFILE
