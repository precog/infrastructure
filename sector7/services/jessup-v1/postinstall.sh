#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Stop and start the service
stop jessup-v1
sleep 5
start jessup-v1

# Restart monit to pick up changes
/etc/init.d/monit restart

# Wait 30 seconds for startup, then test the health URL
sleep 30

set -e

curl -f -G "http://localhost:30030/blueeyes/services/jessup/v1/health"
