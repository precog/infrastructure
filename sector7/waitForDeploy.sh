#!/bin/bash

if [ "$#" != "5" ]; then
    echo "Usage: `basename $0` <env config> <service> <serial> <minimum deploy count> <timeout in seconds>"
    exit
fi

DEPLOYER=`dirname $0`/tools/deploymanager.rb
SLEEPTIME=15

TOTALTIME=0

while (( $TOTALTIME < $5 )) ; do
    OUTPUT=`$DEPLOYER $1 listconfigs $2 $3`

    # First, make sure that it exists and that it's stable
    if ! echo "$OUTPUT" | egrep "$3.*stable=true" > /dev/null ; then
	echo "Serial '$3' doesn't seem to exist or be stable!"
	exit 1
    fi

    # Check to see if it's been deployed
    DEPLOYED=`echo "$OUTPUT" | sed -n -e "s/.*$3.*deployed=\([0-9]*\).*/\1/p"`

    if (( $DEPLOYED >= $4 )) ; then
	echo "Deployed!"
	exit 0
    fi

    if (( $DEPLOYED > 0 )); then
	echo "Deployed to $DEPLOYED servers"
    fi

    # If it got rejected, we fail
    if echo "$OUTPUT" | egrep "$3.*rejected=true" > /dev/null ; then
	echo "Rejected!"
	exit 1
    fi

    # Wait and poll
    echo "Waited $TOTALTIME seconds for deploy"
    TOTALTIME=$(( $TOTALTIME + $SLEEPTIME ))

    sleep $SLEEPTIME
done

echo "Timed out waiting for deployment!"
exit 1
