#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Stop and start the service
stop billing-v1
sleep 5
start billing-v1

# Restart monit to pick up changes
/etc/init.d/monit restart
