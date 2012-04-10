current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "reportgrid"
client_key               "#{current_dir}/reportgrid.pem"
validation_client_name   "reportgrid-validator"
validation_key           "#{current_dir}/validation.pem"
chef_server_url          "https://api.opscode.com/organizations/reportgrid"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
