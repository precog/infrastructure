# Note: http://haproxy.1wt.eu/download/1.3/doc/configuration.txt

default[:haproxy][:enabled] = '1'
default[:haproxy][:log_level] = 'notice'

default[:haproxy][:monitor_uri] = '/haproxy/health'

default[:haproxy][:defaults] = [
  'balance roundrobin',
  'log global',
  'maxconn 19500',
  'mode http',
  "monitor-uri #{haproxy[:monitor_uri]}",
  'option allbackups',
  'option abortonclose',
  'option dontlognull',
  'option httpclose',
  'option httplog',
  'option forwardfor',
  'stats enable',
  'stats hide-version',
  'stats refresh 2s',
  'stats uri /haproxy/stats',
  'timeout client 60s',
  'timeout connect 60s',
  'timeout http-request 5s',
  'timeout server 60s'
]

services = {
  ['analytics', 'v0'] => {
    :servers => (1..4).map { |i| "appserver#{'%02d' % i}.reportgrid.com" },
    :port    => 30010
  }
}

default[:haproxy][:frontend] = [{:http => %Q{
  bind *:80
  #{services.sort.inject([]) { |memo,obj|
    memo << "acl services_#{obj[0][0]}_#{obj[0][1]} path_reg ^/services/#{obj[0][0]}/#{obj[0][1]}/"
    memo << "use_backend services_#{obj[0][0]}_#{obj[0][1]} if services_#{obj[0][0]}_#{obj[0][1]}"
  }.join("\n  ")}
  default_backend website
}}]

backends = []
services.sort.each do |service,params|

  httpchk = 'option httpchk GET '
  httpchk << "/services/#{service[0]}/#{service[1]}" if params[:cache_enabled]
  httpchk << (params.has_key?(:health) ? params[:health] : "/blueeyes/services/#{service[0]}/#{service[1]}/health")
  cache_port = 6081

  health_interval = 1000 * (params.has_key?(:health_interval) ? params[:health_interval] : 5)
  health_threshold = params.has_key?(:health_threshold) ? params[:health_threshold] : 2

  backend_servers = params[:servers].map do |s|
    port = params[:cache_enabled] ? cache_port : params[:port]
    "server #{s}:#{port} #{s}:#{port} check inter #{health_interval} rise #{health_threshold} fall #{health_threshold} #{'backup' if s != fqdn}"
  end

  backends << {
    "services_#{service[0]}_#{service[1]}".to_sym => [
      params[:cache_enabled] ? nil : 'reqrep ^([^\ ]*)\ /services/[[:alnum:]-]+/[[:alnum:]-]+/(.*) \1\ /\2',
      "reqadd X-Service-URL-Root:\ /services/#{service[0]}/#{service[1]}",
      httpchk,
      backend_servers
      ].flatten.reject { |obj| obj.nil? }.join("\n  ")
  }
end
default[:haproxy][:backend] = backends
default[:haproxy][:backend] << {:website => 'server www.reportgrid.com www.reportgrid.com:80'}
