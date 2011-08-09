#!/bin/bash

set -x

export DEBIAN_FRONTEND=noninteractive

EC2_LOCAL_IPV4=`/usr/bin/curl --silent http://instance-data.ec2.internal/latest/meta-data/local-ipv4`
EC2_AMI_LAUNCH_INDEX=`/usr/bin/curl --silent http://instance-data.ec2.internal/latest/meta-data/ami-launch-index`
HOSTNAME='rga-032'
DOMAIN="reportgrid.com"
CHEF_SERVER="api.opscode.com/organizations/reportgrid"
CHEF_CONF="/etc/chef"
JSON_ATTRIBUTES_FILE="/tmp/chef-init.json"
MONGO_INIT_FILE="/tmp/mongo-init.js"

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# set hostname
/bin/echo ${HOSTNAME} > /etc/hostname
/bin/hostname -F /etc/hostname
/bin/echo "${EC2_LOCAL_IPV4} ${HOSTNAME}.${DOMAIN} ${HOSTNAME}" >> /etc/hosts
/usr/sbin/service rsyslog restart

# configure repositories
if [ `/bin/grep -c opscode /etc/apt/sources.list` -lt 1 ]
then
  /bin/echo "deb http://apt.opscode.com/ lucid-0.10 main" >> /etc/apt/sources.list
  /usr/bin/curl -s http://apt.opscode.com/packages@opscode.com.gpg.key | /usr/bin/apt-key add -
fi

# update packages
/usr/bin/aptitude update
/usr/bin/aptitude -y safe-upgrade

# disable monit
#/usr/sbin/service monit stop

# resize and format disks as necessary
/sbin/resize2fs /dev/sda1



# FIXME: reset hostname (due to ec2-init breaking it again)
/bin/hostname -F /etc/hostname
/usr/sbin/service rsyslog restart

# install chef
if [ ! -d ${CHEF_CONF} ]
then
  /bin/echo "chef chef/chef_server_url string https://${CHEF_SERVER}" | debconf-set-selections
  /usr/bin/aptitude -y install chef
fi

# kill existing chef clients
if [ `pgrep -c chef-client` -gt 0 ]
then
  /usr/bin/killall -9 chef-client
fi

# delete existing client.pem
if [ -f ${CHEF_CONF}/client.pem ]
then
  /bin/rm ${CHEF_CONF}/client.pem
fi

echo 'validation_client_name "reportgrid-validator"' >> /etc/chef/client.rb

# write validation.pem
/bin/cat <<END > ${CHEF_CONF}/validation.pem
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAslslCsaqw+FX1Gw9lMALYzXfXGXsPt96glx22CwW2vdpNEsZ
UBJ2tF6E6bVRHzvBmiorHEHo5npnBy7YF3FjKQAfRoYjl15ADH0LTp4rMZTfkUhF
aYXRfMAkwCUR2+p2tpZ8K314YaqSO7Vei8NT7bnb7ts6hixrNS15O27nQNz3dRZx
rf1XR4WSXj9lELxbn9Y30cpxhhRgdvMM1vVieoKOhtkjSMDbhCAX2IgDF+F5OaNv
wh93y5P/xnD8fN5pFuKIL00rRpAJXq09570k06Rbvle3QKioJAZbpmF43/7WWs23
+c1WNfa9lI3KrbN+IpT0+ZRJkYToXwBmhOcThwIDAQABAoIBABpPn9NLI33qDE7l
+N+sxQFJvT2gO4264hPBGDcjqet7fCWevok1cBWDrA/eE62L3y+i8OEmR/lYLUK+
AlrS+1HdFsAMoct+t+wftj9Ozghucdy40KSUfSbuIX3G+i97EzA0WvT/eXbO9uug
AeaUVhlHxc4iwStx+g7KOowt/CdxMm46qjK8DpanQuHVOfPR7cdBw80iSerw/zoE
2glmNsbjCvm65DA0ktXI3ib5A5yfMighDinMZJMNsNq74ggy+X/+QVOYIsWCY0L6
cNI82zj6ZLn2Oe28TRlx+6B6grNZcUW584wiMQnpEr8Gb5NnaAraug4FdKLaD7Dg
IyPBHmECgYEA280rJyFstdzf2S8gO5w8GDQMGK2VZBvxqGuoGCGD7/TkpC+o77aC
ZGPrNtq57UOnp+pf1DStYBs2xBlCmYVOG1njgQStWxJGL71zrPh445MEvqGfbAiZ
/lQ3uVpWsoAe+v7bmdiPcEhtojwSDoCk0Axm4qjP+2g0Vi+G7phrxM0CgYEAz7qj
Jps6Rgt8RPb7r4R/X6tZ+yi00A5w0+0awy+qAIbW9HzzdeYcEWIzSrNDDfKnyoyB
MLaUWLx8DqaYSGE92w7gRvwxtBfEKcW4kLRwRwd94x0QvKgOzNLnLZ4tOC93g0I6
h+KZYQAD2Li65fba5sxIa7BsHMvTNF8kNJBT2aMCgYBbNGUllY8AX6ha/F0Jnyio
emBSlSSaJ6Y81n8nlDClDx8YqdYVsculUHi3iEcCFsKowG4HJdyTNnehI0IpZdEl
NEVcsc4lLg4FnT00lt3CwKyFVZdLQr5zdAqzVLMI2nUAfWQuEFhkpQko+ngboHHD
CoJepuG2VmTxJkN9Ga4OOQKBgBEcGFAXvQcD7ypnBXgBe9RPcsvjIHF6nwR1pRyq
kmAUuyPMHul5GJq98eeXOFCvye4/AG0YvMNKUxWJ10Uu7T9bzFFMeHOS+Y9PP9J7
ajwPe+j2/efsF7v7Kxtwydy03C0tiVCj82ov7CEvpgVG/eTAsr5b+6urhivsIjlK
If3tAoGANJKdeO1q85LBcf3TKK6owx+x/caPjvzzeHRdduUSlZ9pSseih4FXeFvu
l5m6hOQP5S9Y34HVEfBIN25RWCa2RTeIzRgo64+sCakqf1NN2Gnl/23GNqzQWMoL
mPDG6fERBvPfRWftfhQMMMZrXU382nbm3yRrcNr3wNrNHtH0MmA=
-----END RSA PRIVATE KEY-----
END

# write temporary json file
/bin/cat <<END > ${JSON_ATTRIBUTES_FILE}
{"run_list": [ "role[default]", "role[appserver]" ] }
END

# do initial (non-daemonized) chef run
/usr/bin/chef-client -l debug -j ${JSON_ATTRIBUTES_FILE}


# start chef daemon
/usr/sbin/service chef-client start

# enable monit
#/usr/sbin/service monit start


