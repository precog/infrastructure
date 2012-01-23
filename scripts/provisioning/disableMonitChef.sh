#!/bin/bash

for srv in "$@"; do
	ssh $srv "sudo bash -c '/etc/init.d/monit stop; /etc/init.d/chef-client stop; stop deployer; sed -e \"s/startup=1/startup=0/\" -i /etc/default/monit ' "
done
