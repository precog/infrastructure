#!/bin/bash

for server in "$@"; do
    ssh $server "sudo bash -c 'stop analytics-v1; stop billing-v1; stop jessup-v1; stop vistrack-v1 ; mv /var/log/reportgrid /mnt/ && ln -s /mnt/reportgrid /var/log/ && start analytics-v1 && start billing-v1 && start jessup-v1 && start vistrack-v1'"
done
