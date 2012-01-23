#!/bin/bash

echo "echo 'rs.initiate({ _id : \"shard$1\", members : [ { _id : 0, host : \"shard$1-01.$2.reportgrid.com:27018\" }, { _id : 1, host : \"shard$1-02.$2.reportgrid.com:27018\" }, { _id : 2, host : \"shard$1-03.$2.reportgrid.com:27018\", arbiterOnly : true } ] })' | mongo --port 27018"
echo "echo 'db.runCommand( { addshard : \"shard$1/shard$1-01.$2.reportgrid.com:27018,shard$1-02.$2.reportgrid.com:27018\" });' | mongo admin"
 
