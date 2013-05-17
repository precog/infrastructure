# IDE settings
default[:precog][:ide][:root] = "/var/www/ide"
# we can override for dev, QA, environments, etc
default[:precog][:ide][:s3url] = "s3://ops.reportgrid.com/ide-prod/"

# Labcoat 2 settings
default[:precog][:raptor][:root] = "/var/www/labraptor"

# Builder settings
default[:precog][:builder][:root] = "/var/www/builder"
# we can override for dev, QA, environments, etc
default[:precog][:builder][:s3url] = "s3://ops.reportgrid.com/builder-prod/"
