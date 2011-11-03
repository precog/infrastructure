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
