log_level                :info
log_location             STDOUT
node_name                'precog'
client_key               'precog.pem'
validation_client_name   'chef-validator'
validation_key           'validation.pem'
chef_server_url          'http://devops01.reportgrid.com:4000'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ['.']
