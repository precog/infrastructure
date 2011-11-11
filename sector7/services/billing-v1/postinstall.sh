#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Stop and start the service
stop billing-v1
sleep 5
start billing-v1

# Restart monit to pick up changes
/etc/init.d/monit restart

# Wait 30 seconds for startup, then test the health URL
sleep 30

set -e

curl -f -G "http://localhost:30040/blueeyes/services/billing/v1/health"
