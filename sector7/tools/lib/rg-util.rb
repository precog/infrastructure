#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.
#

require 'digest/md5'
require 'logger'

class Util
  attr_writer :log

  def self.file_mode(file)
    sprintf("0%3o", File.stat(file).mode & 0x1ff)
  end

  def self.valid_hash (target, source, s3cfg, log)
    source_hash = `s3cmd --config #{s3cfg} info #{source} | awk '/MD5 sum/{print $3}'`.strip

    if $? != 0 then
      raise "Unable to obtain hash for #{source}"
    end
    
    file_hash = Digest::MD5.hexdigest(IO.read(target))

    log.debug("#{source_hash} == #{file_hash} : #{source_hash == file_hash}")

    return source_hash == file_hash
  end

end
