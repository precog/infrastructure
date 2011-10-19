default[:ec2][:access_key] = "AKIAIQVREYXKPKIKCBEA"
default[:ec2][:secret_key] = "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"

default[:ec2][:ephemeral_backups] = "/mnt/backups"

default[:ec2][:route53][:log] = '/var/log/route53.log'
default[:ec2][:route53][:flagfile] = '/var/run/route53.hasrun'

# Add additional DNS aliases at the node level
default[:ec2][:route53][:aliases] = []
