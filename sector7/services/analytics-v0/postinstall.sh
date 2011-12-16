#!/bin/bash

# Reload the upstart config
initctl reload-configuration

# Reload monit to pick up the changes
/etc/init.d/monit restart

# Stop the service
stop analytics-v0
