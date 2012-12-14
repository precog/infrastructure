#!/bin/bash

if [[ $# < 3 ]]; then
    echo "Usage: `basename $0` <root data dir> <accounts db> <recipients...>"
    exit 1
fi

declare -A accounts

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
	accounts[$ACCOUNT]=$(echo ${accounts[$ACCOUNT]:-0} " + $SIZE" | bc | sed 's/^\./0./')
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

echo -e "Account,Usage in KB,Account Email" > $USAGEFILE
rm -f $ACCTJSONFILE
for account in ${!accounts[@]}; do
  EMAIL=`echo "db.accounts.find({\"accountId\":\"$account\"}).forEach(function(x) { printjson(x.email)})" | mongo --quiet $ACCTDB 2>1`
  if [ -n "$EMAIL" ]; then
    echo -e "$account,${accounts[$account]},$EMAIL"
    echo -e "{ \"timestamp\":\"$TIMESTAMP\", \"server\":\"$SERVERID\", \"account\":\"$account\", \"usage\":${accounts[$account]}, \"email\":$EMAIL}" >> $ACCTJSONFILE 
  fi
done | sort -n -k 1 >> $USAGEFILE
shift 2

#echo "Usage attached" | mutt -s "$ACCTDB usage" -a $USAGEFILE -- "$@"
curl -Ss -X POST --data-binary @$ACCTJSONFILE 'https://beta.precog.com/ingest/v1/sync/fs/0000000828/byAccount/?apiKey=907C4B1E-A00D-4B1D-A191-90D4DE00EEB6'
