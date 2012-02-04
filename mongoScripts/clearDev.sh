#!/bin/bash

if ! hostname | grep dev; then
	echo "This is not a dev server!"
	exit
fi

echo "db.dropDatabase();" | mongo analytics1
echo "db.dropDatabase();" | mongo events1

mongo analytics1 < createAnalytics1.js
mongo events1 < createEvents1.js
