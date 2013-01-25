#!/bin/bash

if [ $# -lt 2 ]
then
	cat <<-EOF
		Syntax:

			$0 <transition> <issue-id>*
	EOF
	exit 1
fi

curlJIRA() {
	if [ $# -eq 4 ]
	then
		curl -s -H "Authorization: Basic cHJlY29nYWRtaW46TGV3aXNDYXJyb2xs" -X $1 -H "Content-Type: application/json" "https://precog.atlassian.net/rest/api/2/$2/$3$4" 
	elif [ $# -eq 5 ]
	then
		curl -s -H "Authorization: Basic cHJlY29nYWRtaW46TGV3aXNDYXJyb2xs" -X $1 -H "Content-Type: application/json" "https://precog.atlassian.net/rest/api/2/$2/$3$4" --data "$5"
	else
		cat <<-EOF
			Invalid number of parameters to jiraCMD: $*
			Expected: HTTP-VERB APIGROUP APIKEY path-or-parameters [data]

			In the absence of a path or parameter, pass an empty string.
		EOF
		exit 2
	fi
	
}

chomp() {
	echo "$*" | tr -d '\n'
}

jiraCMD() {
	curlJIRA "$@"
}

jiraCMDPrettyJSON() {
	jiraCMD "$@" | python -mjson.tool
}


getTransitions() {
	jiraCMDPrettyJSON GET issue "$1" /transitions | grep -B2 -F '"to"'  | grep -B1 -F '"name"'
}

getTransition() {
	getTransitions "$1" /transitions | grep -B1 -F -i "$2" | head -1 | tr -d ','
}

makeTransition() {
	TID=$(chomp $(getTransition "$1" "$2") | cut -d ':' -f 2)
	if [ -n "$TID" ]
	then
		RESPONSE=$(jiraCMD POST issue "$1" /transitions "{ \"transition\": $TID }")
		if [ -n "$RESPONSE" ]
		then
			echo $RESPONSE
			return 4
		fi
	else
		echo "Transition $2 not available for issue $1"
		return 8
	fi
}

TRANSITION="$1"; shift

RESULT=0
for ISSUE in "$@"
do
	makeTransition "$ISSUE" "$TRANSITION"
	RESULT=$(($RESULT | $?))
done

exit $RESULT

