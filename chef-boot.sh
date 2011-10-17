#!/bin/bash

case "$#" in
    1)
        HOST=$1
        NODE=$1
	shift
        ;;
    2)
        HOST=$1
        NODE=$2
	shift
	shift
        ;;
    0)
        echo "Usage: $0 <hostname> [<node name>]"
        exit
esac

knife bootstrap --identity-file ec2/ec2-keypair.pem --ssh-user ubuntu --sudo --node-name ${NODE} ${HOST} "$@"
