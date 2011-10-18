#!/bin/sh

if [ "$#" -ne "1" ]; then
  echo "Usage: fix-rackspace.sh <IP>"
  exit
fi

ssh root@${1} "sed -e 's/\([^.]*\).*/\1/' -ibak /etc/hostname && \
sed -ibak 's/^\([0-9.]*\)[ ]*\([^.]*\)\.reportgrid\.com.*/\1  \2.reportgrid.com \2/' /etc/hosts && \
hostname -F /etc/hostname && \
hostname"