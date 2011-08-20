#!/bin/bash

STATUS=`curl --silent http://localhost:30020/blueeyes/services/analytics/v1/health`
if [[ -n $STATUS ]]
then
  echo $STATUS
else
  echo "ERROR"
fi
