#
# Copyright 2011, ReportGrid, Inc.

class Uploader
  def initialize(s3cfg, log)
    @s3cfg = s3cfg
    @log = log
  end

  def file_for (service, source, symlink, mode, alias_ok, root)
    source = File.expand_path(source)
    if not File.readable?(source) then
      @log.error("Can't read #{source}!")
      exit(-2)
    end

    # Simple sanity check on mode to add a leading zero
    if mode then mode = sprintf("0%3o", mode.oct) end

    # Convert source into an S3 URL
    url = "#{root}#{service}/#{source.split('/').last}"

    # First, check if the file exists
    if Util.s3_file_exists(url, @s3cfg, @log)  then
      # If this is an identical file URL, check to see if it's the same file
      if not Util.valid_hash(source, url, @s3cfg, @log) then
        # file exists, but is different. If it's a symlink we can make an alias
        if symlink or alias_ok then
          @log.info("Aliasing existing URL : #{url}")
          url = "#{url}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
        else
          @log.error("Can't replace existing file: #{url}")
          exit(-2)
        end
      end
    end

    { "source" => source, "symlink" => symlink, "mode" => mode, "url" => url }.delete_if {|k,v| v == nil}
  end

  def upload (entry)
    source = entry["source"]
    url = entry["url"]

    # Upload the file if needed
    if not Util.s3_file_exists(url,@s3cfg,@log) or not Util.valid_hash(source, url, @s3cfg, @log) then
      upload_result = `s3cmd put #{source} #{url}`

      if $? != 0 then
        @log.error("Error uploading #{source}: #{upload_result}")
        exit(-2)
      end
      
      @log.info("Uploaded #{source} => #{url}")
    else
      @log.info("Skipped existing #{url}")
    end

    entry["source"] = url
    entry.delete("url")
    
    entry
  end
end
