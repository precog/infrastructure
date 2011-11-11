#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Stop and start the service
stop analytics-v0
sleep 5
start analytics-v0

# Restart monit to pick up changes
/etc/init.d/monit restart
