#!/bin/bash

HOST="api.reportgrid.com"
SERVICE_ROOT="/services/analytics/v0"
USER="mike"
COUNT=1000
TOKEN_ID="4EE559F7-C8B9-41AA-B4E3-1F2197781C3D"
EVENT="click"

# curl -H "Content-Type: application/json" "http://api.reportgrid.com/tokens/?tokenId=8E680858-329C-4F31-BEE3-2AD15FB67EED" -d "{\"path\": \"/mike/\"}"
# curl -H "Content-Type: application/json" "http://api.reportgrid.com/tokens/?tokenId=8E680858-329C-4F31-BEE3-2AD15FB67EED"


CURR=$(date +%s)
for ((i=1; i<=$COUNT; i++))
do
  TIMESTAMP=${CURR}000
  echo "[$i] Sending \"${EVENT}\" event with timestamp: ${TIMESTAMP}"
  curl -H "Content-Type: application/json" "http://${HOST}/${SERVICE_ROOT}/events/vfs/${USER}/?tokenId=${TOKEN_ID}" -d "{\"timestamp\": ${TIMESTAMP}, \"event\":{\"${EVENT}\": {}}}"
  let CURR=($CURR+$RANDOM%60)
done

curl -H "Content-Type: application/json" "http://${HOST}/${SERVICE_ROOT}/reports/events/summary/vfs/${USER}/?tokenId=${TOKEN_ID}"
