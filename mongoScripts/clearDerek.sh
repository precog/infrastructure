#!/bin/bash

PATH=$PATH:/Users/dchenbecker/Tools/mongodb-osx-x86_64-2.0.1/bin/

if ! hostname | grep Derek; then
	echo "This is not Derek's laptop!"
	exit
fi

echo "db.dropDatabase();" | mongo analytics1
echo "db.dropDatabase();" | mongo events1

mongo analytics1 < createAnalytics1.js
mongo events1 < createEvents1.js
