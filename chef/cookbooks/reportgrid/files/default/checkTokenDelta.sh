#!/bin/bash

echo "db.tokens.find().forEach(function(obj) { print(obj.tokenId) });" | mongo --quiet analytics1 | grep -v bye | sort | uniq -c > /tmp/tokens_now

ec=0

if [ -e /tmp/tokens_before ]
then
  result=`diff /tmp/tokens_now /tmp/tokens_before`
  if [ $? -ne 0 ]
  then
    echo Change in token collection
    echo "$result"
    ec=1
  fi
fi
mv /tmp/tokens_now /tmp/tokens_before
exit $ec
