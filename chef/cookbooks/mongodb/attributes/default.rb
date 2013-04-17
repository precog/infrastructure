default[:mongodb][:version] = '2.4.1'
default[:mongodb][:package] = 'mongodb-10gen'

default[:mongodb][:data_device]      = File.blockdev?('/dev/mapper/VolGroupMongoDB-LogVolMongoDB') ? "/dev/mapper/VolGroupMongoDB-LogVolMongoDB" : "/dev/sdh"
default[:mongodb][:data_mount_point] = "/srv/mongodb"

default[:mongodb][:port][:config]     = 27019
default[:mongodb][:port][:shard]      = 27018
default[:mongodb][:port][:mongos]     = 27017
default[:mongodb][:port][:standalone] = 27017

default[:mongodb][:mongos_enabled] = "yes"
default[:mongodb][:journaling] = "journal = true"

default[:mongodb][:use_fqdn_prefix_for_replset] = false

if hostname =~ /^rg.*/
  default[:mongodb][:config_servers] = [
    'rgmconf-013.reportgrid.com:27019',
    'rgmconf-014.reportgrid.com:27019',
    'rgmconf-015.reportgrid.com:27019'
  ]
else
  default[:mongodb][:config_servers] = [
    'mongodb-config01.reportgrid.com:27019',
    'mongodb-config02.reportgrid.com:27019',
    'mongodb-config03.reportgrid.com:27019'
  ]
end
