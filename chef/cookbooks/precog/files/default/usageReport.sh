#!/bin/bash

if [[ $# < 3 ]]; then
    echo "Usage: `basename $0` <root data dir> <accounts db> <recipients...>"
    exit 1
fi

declare -A accountsUsage

BASEDIR=$1
ACCTDB=$2
USAGEFILE="/tmp/Usage-$ACCTDB-`date '+%F'`.csv"
ACCTJSONFILE="/tmp/Usage-$ACCTDB-`date '+%F'`.json"
MINPATHSIZE=3
#TIMESTAMP=$(date -u "+%Y%m%dT%H%M%SZ")
TIMESTAMP=$(date -u "+%F")
SERVERID=$(hostname)

for ACCTDIR in $(cd $BASEDIR; ls); do
	SIZE=$(echo "scale=2; `du -sk $BASEDIR/$ACCTDIR | cut -f 1` / 1024" | bc )
	ACCOUNT=`echo $ACCTDIR | tr -d '/'` 
	#echo "$ACCOUNT:$SIZE"
	accountsUsage["$ACCOUNT"]=$(echo "$SIZE" | sed 's/^\./0./')
	#declare -A PATHSIZE
	#for subdir in `find $BASEDIR/$ACCTDIR -name projection_descriptor.json`; do
	#	SIZE=$(echo "scale=2; $(du -sk $(dirname $subdir) | cut -f 1) / 1024" | bc)
	#	ACCTPATH=$(dirname $subdir | sed "s:$BASEDIR/$ACCTDIR\(.*\)/[^/]*:\1:")
	#	REALPATH=${ACCTPATH:-/}
	#	#echo "  ${REALPATH:-/}:$SIZE"
	#	PATHSIZE[$REALPATH]=$(echo ${PATHSIZE[$REALPATH]:-0} "+ $SIZE" | bc )
	#done

	##echo "  per-path:"
	#for acctpath in ${!PATHSIZE[@]}; do
	#	echo "  testing $acctpath:${PATHSIZE[$acctpath]}"
	#	if [[ $(echo "${PATHSIZE[$acctpath]} >= $MINPATHSIZE" | bc) == 1 ]]; then
	#	  echo "  $acctpath:${PATHSIZE[$acctpath]}"
	#	fi
	#done
done

# Output data for all accounts
rm -f $ACCTJSONFILE
echo -e "Account,Account Email,Creation timestamp,Usage in KB" > $USAGEFILE
for acctEntry in $(echo "db.accounts.find().forEach(function(x) { print(x.accountId + ',' + x.email + ',' + x.accountCreationDate) })" | mongo --quiet $ACCTDB 2>1); do
    IFS="," read -a PARTS <<< "$acctEntry"
    account=${PARTS[0]}
    if [ -z "$account" ]; then
        echo "Bad account info: $acctEntry" >&2
    else
        USAGE=${accountsUsage["$account"]:-0}
        echo -e "$acctEntry,$USAGE"
        echo -e "{ \"timestamp\":\"$TIMESTAMP\", \"server\":\"$SERVERID\", \"account\":\"$account\", \"usage\":$USAGE, \"email\":\"${PARTS[1]}\", \"creationDate\":${PARTS[2]}}" >> $ACCTJSONFILE 
    fi
done | sort -n -k 1 >> $USAGEFILE
shift 2

#echo "Usage attached" | mutt -s "$ACCTDB usage" -a $USAGEFILE -- "$@"
curl -Ss -X POST -H 'Content-Type: application/json' --data-binary @$ACCTJSONFILE 'https://beta.precog.com/ingest/v1/sync/fs/0000000828/byAccount/?apiKey=907C4B1E-A00D-4B1D-A191-90D4DE00EEB6'
