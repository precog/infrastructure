#!/bin/zsh

if (( $# < 3 )); then
    echo "Usage: `basename $0` <ip> <password> <desired fqdn> [<additional chef args>]"
    exit
fi

IP=$1
PASS=$2
FQDN=$3

shift 3

if host $IP | grep -v pointer > /dev/null ; then
    IP=`dig +short $IP`
fi

echo "Launching instance at $IP"


# Fix hosts/hostname
`dirname $0`/pre-chef.sh $IP $FQDN $PASS

`dirname $0`/chef-boot.sh $IP "root:$PASS" $FQDN "$@"