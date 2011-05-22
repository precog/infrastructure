#!/bin/bash

STATUS=`curl --silent http://localhost:30010/blueeyes/services/analytics/v0/health`
if [[ -n $STATUS ]]
then
  echo $STATUS
else
  echo "ERROR"
fi
