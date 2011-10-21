#!/bin/zsh

if (( $# < 2 || $# > 3 )); then 
    echo "Usage: `basename $0` <IP> <FQDN> [<root password>]"
    exit
fi

IP=$1
FQDN=$2
PASS=$3
TIMESTAMP=`date "+%Y%m%d%H%M%S"`

HOSTNAME=`echo $FQDN | cut -d'.' -f1`

SCRIPT="mv /etc/hostname /etc/hostname.${TIMESTAMP} && echo ${HOSTNAME} > /etc/hostname && \
mv /etc/hosts /etc/hosts.${TIMESTAMP} && \
echo -e \"127.0.0.1\tlocalhost localhost.localdomain\n${IP}\t${FQDN} ${HOSTNAME}\" > /etc/hosts &&
hostname -F /etc/hostname && \
hostname"

echo "Fixing hostnames/hosts on $IP to $FQDN ($HOSTNAME)"

if (( $# == 2 )) then
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i `dirname $0`/../ec2/ec2-keypair.pem ubuntu@${1} "sudo bash -c '$SCRIPT'"
else
    sshpass -p $PASS ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${1} ${SCRIPT}
fi

echo "Fixup complete"