#!/bin/bash

SEC="mongodb$(( $2 + 1 ))"
ARB="mongodb$(( $2 + 2 ))"

echo "echo 'rs.initiate({ _id : \"$1\", members : [ { _id : 0, host : \"mongodb$2.reportgrid.com:27018\" }, { _id : 1, host : \"$SEC.reportgrid.com:27018\" }, { _id : 2, host : \"$ARB.reportgrid.com:27018\", arbiterOnly : true } ] })' | mongo --port 27018"
echo "echo 'db.runCommand( { addshard : \"$1/mongodb$2.reportgrid.com:27018,$SEC.reportgrid.com:27018\" });' | mongo admin"
 
