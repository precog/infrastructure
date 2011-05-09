# Note: http://haproxy.1wt.eu/download/1.3/doc/configuration.txt

default[:haproxy][:enabled] = '1'

default[:haproxy][:defaults] = [
  'balance roundrobin',
  'log global',
  'maxconn 19500',
  'mode http',
  'option abortonclose',
  'option dontlognull',
  'option httpclose',
  'option httplog',
  'option forwardfor',
  'retries 5',
  'stats enable',
  'stats hide-version',
  'stats uri /haproxy?stats',
  'stats auth admin:haGrid7',
  'timeout client 60s',
  'timeout connect 4s',
  'timeout http-request 5s',
  'timeout queue 60s',
  'timeout server 60s'
]

real_servers_prefix = 'mongodb'
real_servers = [1, 2, 4, 5]
cache_servers_prefix = 'varnish'
cache_servers = ()
services = [
  ['analytics', 'v0', 30010, false],
]

acls = []
services.each do |service,version,port,cache|
  acls.push("acl services_#{service}_#{version} path_reg ^/services/#{service}/#{version}/")
  acls.push("use_backend services_#{service}_#{version} if services_#{service}_#{version}")
end

default[:haproxy][:frontend] = [{
  :http => [
    'bind *:80',
    acls,
    'default_backend website'].flatten
}]

backends = []
services.each do |service,version,port,cache|

  httpchk = 'option httpchk GET '
  if cache
    httpchk << "/services/#{service}/#{version}"
  else
    httpchk << "/blueeyes/services/#{service}/#{version}/health"
  end

  backend_servers = []
  if cache
    cache_servers.each do |server_id|
      backend_servers.push("server #{cache_servers_prefix}%02d #{cache_servers_prefix}%02d.reportgrid.com:80 check inter 10000" % [server_id, server_id])
    end
  else
    real_servers.each do |server_id|
      backend_servers.push("server #{real_servers_prefix}%02d #{real_servers_prefix}%02d.reportgrid.com:#{port} check inter 10000" % [server_id, server_id])
    end
  end

  backends.push({
    "services_#{service}_#{version}".to_sym => [
      cache ? nil : 'reqrep ^([^\ ]*)\ /services/[[:alnum:]-]+/[[:alnum:]-]+/(.*) \1\ /\2',
      #httpchk,
      backend_servers
      ].flatten.reject { |obj| obj.nil? }
  })
end

default[:haproxy][:backend] = backends

default[:haproxy][:backend].push({:website => [ 'server www.reportgrid.com www.reportgrid.com:80' ]})
