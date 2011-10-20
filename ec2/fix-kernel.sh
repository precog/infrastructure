#!/bin/zsh

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 <instance name>"
    exit
fi

function stopInstance() {
    ec2-stop-instances --region ${REGION} ${IID} || { echo "Failed to stop the instance"; exit } 2> /dev/null

    while [ "`ec2-describe-instances ${IID} | awk -F'\t' '/INSTANCE/{ print $6}'`" != "stopped" ]; do
	echo "Waiting for shutdown"
	sleep 5
    done
}

function startInstance() {
    ec2-start-instances --region ${REGION} ${IID} || { echo "Failed to start the instance"; exit } 2> /dev/null

    while [ "`ec2-describe-instances ${IID} | awk -F'\t' '/INSTANCE/{ print $6}'`" != "running" ]; do
	echo "Waiting for startup"
	sleep 5
    done
}

    
IDATA=`ec2-describe-instances`

# First, locate instance ID and region
IID=`echo ${IDATA} | awk -F'\t' "/TAG.*Name\t$1/{ print \\$3 }"`

if [ -z "$IID" ]; then
    echo "Could not locate instance '$1'"
    exit
fi

if [ `echo ${IID} | wc -l` -gt 1 ]; then
    echo -e "Multiple IIDs match '$1'. This is not supported (yet):\n${IID}"
    exit
fi

REGION=`echo ${IDATA} | awk -F'\t' "/INSTANCE\t${IID}/{ print \\$12}" | sed -e 's/\(us-.*-[0-9]\).*/\1/'`
HOSTNAME=`echo ${IDATA} | awk -F'\t' "/INSTANCE\t${IID}/{ print \\$4 }"`
DISKS=`echo ${IDATA} | awk -F'\t' "/INSTANCE\t${IID}/{startdisks=1} /BLOCKDEVICE/{if (startdisks) print \\$3} /TAG/{startdisks=0}"`

echo "IID:\t\t${IID}\nRegion:\t\t${REGION}\nHostname:\t${HOSTNAME}\nDisks:\n${DISKS}"

read 'ANSWER?Are you sure you want to perform the instance change? Answer "yes" to proceed: '

if [ "$ANSWER" != "yes" ]; then
    echo "Aborting"
    exit
fi

echo "Creating volume snapshots"

echo "  Stopping instance prior to snapshots"
stopInstance

TIMESTAMP=`date "+%Y%m%d-%H%M%S"`

for vol in ${DISKS}; do
    echo "  Taking snapshot of volume ${vol}"
    SNAPID=`ec2-create-snapshot -d "AKI upgrade snapshot ${TIMESTAMP}" ${vol} | awk -F'\t' '/SNAPSHOT/{print $2}' || { echo "Snapshot failed!"; exit } ` 
    
    while [ "`ec2-describe-snapshots ${SNAPID} | awk -F'\t' '/SNAPSHOT/{ print $4 }'`" != "completed" ]; do
	echo "    Waiting on snapshot ${SNAPID}"
	sleep 5
    done
done

echo "  Restarting instance post-snapshot"
startInstance

echo "Sleeping 30 seconds for SSH to start"
sleep 30

echo "Upgrading ${HOSTNAME} packages and installing grub-legacy-ec2"

# Tip for disabling host key check from http://linuxcommando.blogspot.com/2008/10/how-to-disable-ssh-host-key-checking.html
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i `dirname $0`/ec2-keypair.pem ubuntu@${HOSTNAME} "sudo aptitude update && sudo aptitude -y safe-upgrade && sudo aptitude install grub-legacy-ec2" || { echo "Failed to upgrade!" ; exit }

echo "Stopping instance for kernel AKI change"
stopInstance

# We assume everyone is x86_64 and us-east
echo "Modifying kernel"
ec2-modify-instance-attribute --region ${REGION} --kernel aki-427d952b ${IID} || { echo "Failed to modify kernel"; exit }
echo "Starting instance"
startInstance
echo "Done"
