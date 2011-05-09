#!/usr/bin/env ruby
#
# This script performs a simple MongoDB health check.
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#

require 'rubygems'
require 'json'
require 'logger'
require 'mongo'
require 'optparse'
require 'pp'

# set default command line options
options = {
  :hosts      => [],
  :database   => 'health',
  :collection => 'health',
  :log_level  => 'info'
}

# parse command line options
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]\n" \
  + "Example: #{$0} -h mongodb01.example.com:27017 -h mongodb02.example.com:27017"

  opts.on('-h', '--hosts VALUE', 'Host list (default: localhost:27017)') do |opt|
    options[:hosts] << opt
  end

  opts.on('-d', '--database VALUE', 'Database (default: %s)' % options[:database]) do |opt|
    options[:database] = opt
  end

  opts.on('-c', '--collection VALUE', 'Collection (default: %s)' % options[:collection]) do |opt|
    options[:collection] = opt
  end

  opts.on('-v', '--verbosity VALUE', 'Log verbosity (default: %s)' % options[:log_level]) do |opt|
    options[:log_level] = opt
  end

end.parse!

# make sure a valid hostname:port is specified
options[:hosts] << 'localhost:27017' if options[:hosts].length < 1
options[:hosts].map! do |obj|
  if ! obj.include?(':')
    obj << ':27017'
  end
  obj.split(':')
end

# instantiate logger
log = Logger.new(STDOUT)
log.level = eval('Logger::' + options[:log_level].upcase)

# do health check
begin
  log.info("Connecting to: %s" % options[:hosts].map { |obj| obj.join(':') }.join(', '))
  conn = Mongo::Connection.multi(options[:hosts])

  if conn.database_names.is_a?(Enumerable)
    log.info("Enumerating databases...")
    conn.database_names.each do |db|
      log.debug("Found database: %s" % db)
      conn.db(db).collection_names.each do |coll|
        log.debug("Found collection: %s" % coll)
      end
    end
    log.info('Done')

  else
    log.error('No databases found')
  end

rescue Mongo::MongoRubyError, Mongo::MongoDBError
  log.error($!.message)
end
