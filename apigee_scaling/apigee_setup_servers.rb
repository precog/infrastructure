#!/usr/bin/ruby

require 'erb'

def build_appserver_user_data(template, params)
  ERB.new(File.open(template, 'r').read).result(binding)
end

def build_server(hostname, group, zone, instance_type, sda_size, data_size, roles, params = {}) 
  device_names = case group
    when "mongodb" 
      if instance_type == "t1.micro"
        [{:device_name =>"/dev/sda1", :size => sda_size}]
      else 
        [
          {:device_name =>"/dev/sda1", :size => sda_size},
          {:device_name => "/dev/sdm", :size => data_size}, 
          {:device_name => "/dev/sdn", :size => data_size},
          {:device_name => "/dev/sdo", :size => data_size},
          {:device_name => "/dev/sdp", :size => data_size}
        ]
      end
    when "appserver" then [
      {:device_name =>"/dev/sda1", :size => sda_size}
    ] 
  end 

  filename = "#{hostname}-init.sh"
  File.open(filename, 'w') do |f| 
    f.puts(
      build_appserver_user_data("setup_servers.erb", 
        {
          :hostname => hostname,
          :block_device_mapping => device_names.reject{|d| d[:device_name] == "/dev/sda1"},
          :chef_run_list => ["role[default]"] + roles
        }.merge(params)
      )
    )
  end

  device_mapping_args = device_names.inject([]) do |acc, value|
    acc << "--block-device-mapping '#{value[:device_name]}=:#{value[:size]}:true'"
  end

  #`ec2-run-instances --key ec2-keypair --availability-zone #{zone} #{device_mapping_args.join(" ")} --instance-type #{instance_type} --group #{group} ami-4a0df923 --user-data-file #{filename}`
  puts "ec2-run-instances --key ec2-keypair --availability-zone #{zone} #{device_mapping_args.join(" ")} --instance-type #{instance_type} --group #{group} ami-4a0df923 --user-data-file #{filename}"
end

def build_appserver_set(hostbase, host_base_id, quantity) 
  host_id = host_base_id
  hosts = 0
  while (hosts < quantity)
    ["us-east-1a", "us-east-1b", "us-east-1c"].each do |zone|
      hostname = "#{hostbase}-%03d" % host_id
      build_server(hostname, "appserver", zone, "m1.large", 25, 0, ["role[appserver]"])
      host_id += 1
      hosts += 1
    end
  end
end

def build_mongo_replicasets(hostbase, host_base_id, quantity)
  hosts = 0
  host_id = host_base_id
  set_id = (host_base_id.to_f / 3).ceil #Deep magic. See mongodb.conf chef recipe replSet parameter
  while (hosts < quantity) 
    hostname = "#{hostbase}-%03d" % host_id
    conf = <<-ENDSCRIPT
      config = { 
        _id: #{set_id},
        members: [
          {_id: 0, host: '#{hostbase}-#{"%03d" % (host_id)}.reportgrid.com:27018'},
          {_id: 1, host: '#{hostbase}-#{"%03d" % (host_id + 1)}.reportgrid.com:27018'},
          {_id: 2, host: '#{hostbase}-#{"%03d" % (host_id + 2)}.reportgrid.com:27018, arbiterOnly:true"}
        ] 
      };
      rs.initiate(config);
    ENDSCRIPT
    build_server(hostname, "mongodb", "us-east-1a", "m2.2xlarge", 15, 500, ["role[mongodb-shard-server]", "role[mongodb-replset-server]"], :mongo => {:replica_set_conf => conf, :db => true})
    host_id += 1
    hosts += 1

    hostname = "#{hostbase}-%03d" % host_id
    build_server(hostname, "mongodb", "us-east-1b", "m2.2xlarge", 15, 500, ["role[mongodb-shard-server]", "role[mongodb-replset-server]"], :mongo => {:db => true})
    host_id += 1
    hosts += 1

    hostname = "#{hostbase}-%03d" % host_id
    build_server(hostname, "mongodb", "us-east-1c", "t1.micro", 15, 0, ["role[mongodb-shard-server]", "role[mongodb-replset-server]"], :mongo => {:db => false})
    host_id += 1
    hosts += 1

    set_id += 1
  end
end

def build_mongo_configservs(hostbase, host_base_id, quantity) 
  host_id = host_base_id
  hosts = 0
  while (hosts < quantity)
    ["us-east-1a", "us-east-1b", "us-east-1c"].each do |zone|
      hostname = "#{hostbase}-%03d" % host_id
      build_server(hostname, "mongodb", zone, "t1.micro", 25, 0, ["role[mongodb-config-server]"])
      host_id += 1
      hosts += 1
    end
  end
end

#build_appserver_set("rga", 15, 27)
build_mongo_replicasets("rgm", 12, 3)
#build_mongo_configservs("rgmconf", 12, 3)
