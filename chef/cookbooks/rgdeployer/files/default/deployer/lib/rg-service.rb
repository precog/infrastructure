#!/usr/bin/env ruby
#
# Copyright 2011, ReportGrid, Inc.
#

require 'rubygems'
require 'json'

class ServiceEntry
  attr_reader :name, :tag, :serial, :stable, :files, :hooks, :deployed, :deploying

  def to_s
    "#{name}.#{serial}"
  end

  class FileEntry
    attr_reader :source, :symlink, :mode

    def initialize(data)
      if not data["source"] then raise "Missing file source!" end

      @source = data["source"]
      @symlink = data["symlink"]
      @mode = data["mode"]
    end

    def to_hash
      data = { "source" => @source, "mode" => @mode }
      if @symlink then data["symlink"] = @symlink end
      data
    end

    # Returns the simple filename from the given source
    def filename
      @source.split('/').last
    end
  end

  def preinstall
    hooks["preinstall"]
  end

  def postinstall
    hooks["postinstall"]
  end

  def preremove
    hooks["preremove"]
  end

  def postremove
    hooks["postremove"]
  end

  def initialize(name, tag, serial, stable, files, hooks, deployed, deploying)
    @name = name
    @tag = tag
    @serial = serial
    @stable = stable
    @files = files
    @hooks = hooks
    @deployed = deployed
    @deploying = deploying
  end

  def to_hash
    data = { "name" => @name, "tag" => @tag, "serial" => @serial, "stable" => @stable,
      "deployedCount" => @deployed, "deployingCount" => @deploying, "files" => @files.map { |f| f.to_hash } }
    @hooks.each { |h,v| data[h] = v.to_hash }
    data
  end

  def to_json
    JSON.generate(to_hash)
  end

  #
  # Generate a ServiceEntry from the input. Input can either be a String
  # or a raw JSON structure (Array/Hash)
  #
  def self.from_json (input)
    data = if input.is_a? String then
             JSON.parse(input)
           else
             input
           end
    
    if not data.has_key?("name") then raise "Missing name attribute!" end
    if not data.has_key?("serial") then raise "Missing serial attribute!" end
    if not data.has_key?("files") then raise "Missing files attribute!" end

    # Set defaults
    if not data.has_key?("stable") then data["stable"] = false end
    data["deployedCount"] ||= 0
    data["deployingCount"] ||= 0
    
    hooks = ["preinstall", "postinstall", "preremove", "postremove"].map { |h|
      [h,if data[h] then FileEntry.new(data[h]) else nil end]
    }.select { |h| h[1] != nil }

    return ServiceEntry.new(data["name"], data["tag"], data["serial"], data["stable"], data["files"].map {|f| FileEntry.new(f) }, Hash[*hooks.flatten], data["deployedCount"], data["deployingCount"])
  end

  def self.from_file (filename)
    data = ServiceEntry.from_json(IO.read(filename))
    return data
  end
end
