default[:mongodb][:version] = '1.8.1'

default[:mongodb][:data_device]      = File.blockdev?('/dev/mapper/VolGroupMongoDB-LogVolMongoDB') ? "/dev/mapper/VolGroupMongoDB-LogVolMongoDB" : "/dev/sdh"
default[:mongodb][:data_mount_point] = "/srv/mongodb"

default[:mongodb][:port][:config]     = 27019
default[:mongodb][:port][:shard]      = 27018
default[:mongodb][:port][:mongos]     = 27017
default[:mongodb][:port][:standalone] = 27017

default[:mongodb][:config_servers] = [
  'mongodb-config01.reportgrid.com:27019',
  'mongodb-config02.reportgrid.com:27019',
  'mongodb-config03.reportgrid.com:27019'
]