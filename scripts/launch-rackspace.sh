#!/bin/zsh

MONGOVERSION=2.1.2

if (( $# < 3 )); then
    echo "Usage: `basename $0` <ip> <password> <desired fqdn> [<additional chef args>]"
    exit
fi

IP=$1
PASS=$2
FQDN=$3

echo "IP = $IP"

shift 3

#if host $IP | grep -v pointer > /dev/null ; then
#    IP=`dig +short $IP`
#fi

if echo "$@" | grep -i mongo; then
    echo "Copying mongo"
    
    sshpass -p $PASS scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ~/Downloads/mongodb_${MONGOVERSION}_amd64.deb root@${IP}:
    sshpass -p $PASS ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${IP} "sudo aptitude -y install xulrunner-dev && sudo dpkg -i mongodb_${MONGOVERSION}_amd64.deb && sudo stop mongodb"
fi

echo "Launching instance at $IP"

# Fix hosts/hostname
`dirname $0`/pre-chef.sh $IP $FQDN $PASS

`dirname $0`/chef-boot.sh $IP "root:$PASS" $FQDN "$@"
