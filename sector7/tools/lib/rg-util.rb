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

  def self.valid_hash (target, url, s3cfg, log)
    sleep = 1
    count = 10

    begin
      url_hash = `s3cmd --config #{s3cfg} info #{url} | awk '/MD5 sum/{print $3}' 2> /dev/null`.strip

      if $? != 0 then
        count = 0
        url_hash = ""
      elsif url_hash.length == 0 then
        sleep(sleep)
        sleep = sleep * 2
        count = count - 1
      end
    end while url_hash.length == 0 && count > 0

    if url_hash.length == 0 then
      raise "Unable to obtain hash for #{url}"
    end

    file_hash = Digest::MD5.hexdigest(IO.read(target))

    log.debug("Comparing hash on #{target} to #{url}")
    log.debug("#{url_hash} == #{file_hash} : #{url_hash == file_hash}")

    return url_hash == file_hash
  end

  def self.s3_file_exists (url, s3cfg, log)
    `s3cmd ls #{url} | grep #{url} > /dev/null 2>&1`

    return $? == 0
  end


end
