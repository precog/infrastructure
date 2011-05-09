default[:ec2][:access_key] = "AKIAIQVREYXKPKIKCBEA"
default[:ec2][:secret_key] = "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"

default[:ec2][:ephemeral_backups] = "/mnt/backups"

default[:ec2][:route53][:log] = '/var/log/route53.log'

default[:ec2][:route53][:opts] = [
  ['--file /root/.route53',
   '--zone reportgrid.com.',
   '--remove',
   '--name %s.' % fqdn,
   '--type CNAME'],
  ['--file /root/.route53',
   '--zone reportgrid.com.',
   '--create',
   '--name %s.' % fqdn,
   '--type CNAME',
   '--ttl 60',
   '--values `/usr/bin/curl --silent http://instance-data/latest/meta-data/public-hostname`' + '.']
]
