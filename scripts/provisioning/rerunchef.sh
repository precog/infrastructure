#!/bin/bash

for srv in "$@"; do
  ssh ${srv} "sudo chef-client -j /etc/chef/first-boot.json && sudo chef-client"
done
