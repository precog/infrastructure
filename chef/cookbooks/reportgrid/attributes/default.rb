default[:reportgrid][:source][:root] = "/root/reportgrid"

#if hostname =~ /^rg.*/
  default[:reportgrid][:mongo][:hosts] = ["localhost:27017"]
#else
#  default[:reportgrid][:mongo][:hosts] = ["mongodb01.reportgrid.com:27018", "mongodb02.reportgrid.com:27018"]
#end
