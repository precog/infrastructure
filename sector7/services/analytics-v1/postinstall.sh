#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Stop and start the service
stop analytics-v1
sleep 5
start analytics-v1

# Restart monit to pick up changes
/etc/init.d/monit restart

# Wait 30 seconds for startup, then test the health URL
sleep 30

set -e

curl -f -G "http://localhost:30020/blueeyes/services/analytics/v1/health"
