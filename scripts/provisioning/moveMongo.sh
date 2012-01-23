#!/bin/bash

for server in "$@"; do
    ssh $server "sudo bash -c 'stop mongodb && mkdir -p /mnt/mongodb && chown mongodb:mongodb /mnt/mongodb && mv /var/lib/mongodb /mnt/mongodb/db && ln -s /mnt/mongodb/db /var/lib/mongodb && start mongodb'"
done