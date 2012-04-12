#!/bin/bash

echo "rs.stepDown();" | mongo --port 27018

mkdir -p /mnt/mongodb/log
mkdir /mnt/mongodb/db

sudo /etc/init.d/monit stop
sudo stop mongodb

if [ ! -L /var/log/mongodb ]; then
    mv /var/log/mongodb/* /mnt/mongodb/log/
    rmdir /var/log/mongodb
    ln -s /mnt/mongodb/log /var/log/mongodb
fi

if [ ! -L /var/lib/mongodb ]; then
    mv /var/lib/mongodb/* /mnt/mongodb/db/
    rmdir /var/lib/mongodb
    ln -s /mnt/mongodb/db /var/lib/mongodb
fi

sudo chown -R mongodb /mnt/mongodb

sudo start mongodb
sudo /etc/init.d/monit start
