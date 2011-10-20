#!/bin/bash

case "$#" in
    0|1)
        echo "Usage: $0 <hostname> <ubuntu|username:password> [<node name>]"
        exit
	;;
    2)
        HOST=$1
	USERNAME=$2
        NODE=$1
	shift
	shift
        ;;
    *)
        HOST=$1
	USERNAME=$2
        NODE=$3
	shift
	shift
	shift
        ;;
esac

if echo ${USERNAME} | grep ubuntu; then
    AUTHOPTS="--identity-file ec2/ec2-keypair.pem --ssh-user ubuntu --sudo"
elif echo ${USERNAME} | grep -v ':'; then
    echo "Non-ubuntu users need a username:password value"
    exit
else
    AUTHOPTS="--ssh-user ${USERNAME%:*} --ssh-password ${USERNAME#*:}"
fi

knife bootstrap ${AUTHOPTS} --node-name ${NODE} ${HOST} "$@"

