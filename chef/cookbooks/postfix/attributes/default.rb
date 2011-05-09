default[:postfix][:relayhost] = '[smtp.sendgrid.net]:587'
default[:postfix][:smtp_sasl_password_maps] = [ 'smtp.sendgrid.net operations@reportgrid.com:seGrid8' ]
default[:postfix][:smtp_generic_maps] = [ '/(.+)@(.+)\.reportgrid\.com/ $2.$1@ec2.reportgrid.com' ]

# FIXME: http://tickets.opscode.com/browse/CHEF-1688
set_unless[:environment] = "production"

case environment
when "staging"
  default[:postfix][:root_email] = "/dev/null"
else
  default[:postfix][:root_email] = "operations@reportgrid.com"
end
