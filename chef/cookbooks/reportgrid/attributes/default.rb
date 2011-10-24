default[:reportgrid][:source][:root] = "/root/reportgrid"

# Visualization settings
default[:reportgrid][:visualization][:root] = "/opt/reportgrid/visualization"
# we can override for dev, QA, environments, etc
default[:reportgrid][:visualization][:deploybranch] = "deploy" 

default[:reportgrid][:eventsdb][:hosts] = ["mongoevents01.reportgrid.com:27017", "mongoevents02.reportgrid.com:27017"]
default[:reportgrid][:indexdb][:hosts] = ["localhost:27017"]
default[:reportgrid][:mongo][:hosts] = ["localhost:27017"] # pre analytics-1.2.0
