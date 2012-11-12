#!/bin/bash

if [[ $# < 3 ]]; then
    echo "Usage: `basename $0` <root data dir> <accounts db> <recipients...>"
    exit 1
fi

declare -A accounts

BASEDIR=$1
ACCTDB=$2
USAGEFILE="/tmp/Usage-$ACCTDB-`date '+%F'`.csv"

for ACCTDIR in $(cd $BASEDIR; ls); do
	SIZE=`du -sk $BASEDIR/$ACCTDIR | cut -f 1`
	ACCOUNT=`echo $ACCTDIR | tr -d '/'` 
	#echo "$ACCOUNT:$SIZE"
	accounts[$ACCOUNT]=$(( accounts[$ACCOUNT] + $SIZE ))
done

echo -e "Account,Usage in KB,Account Email" > $USAGEFILE
for account in ${!accounts[@]}; do
  EMAIL=`echo "db.accounts.find({\"accountId\":\"$account\"}).forEach(function(x) { printjson(x.email)})" | mongo --quiet $ACCTDB 2>1`
  echo -e "$account,${accounts[$account]},$EMAIL"
done | sort -n -k 1 >> $USAGEFILE

shift 2

echo "Usage attached" | mutt -s "$ACCTDB usage" -a $USAGEFILE -- "$@"
