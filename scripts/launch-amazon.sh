#!/bin/zsh

if (( $# < 2 )); then
    echo "Usage: `basename $0` <ip> <desired fqdn> [<additional chef args>]"
    exit
fi

IP=$1
FQDN=$2

shift 2

# Fix hosts/hostname
`dirname $0`/pre-chef.sh $IP $FQDN

`dirname $0`/chef-boot.sh $IP "ubuntu" $FQDN "$@"