#!/bin/zsh

case "$#" in
    1)
	IP=$1
	;;
    2)
	IP=$1
	SSHPASS="sshpass"
	SSHPASSARGS1="-p"
	SSHPASSARGS2="$2"
	;;
    *)
	echo "Usage: fix-rackspace.sh <IP> [<password>]"
	exit
esac

echo "Fixing hostnames/hosts on $IP"

$SSHPASS $SSHPASSARGS1 $SSHPASSARGS2 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
root@${1} "sed -e 's/\([^.]*\).*/\1/' -ibak /etc/hostname && \
sed -ibak 's/^\([0-9.]*\)[ ]*\([^.]*\)\.reportgrid\.com.*/\1  \2.reportgrid.com \2/' /etc/hosts && \
hostname -F /etc/hostname && \
hostname"

echo "Fixup complete"