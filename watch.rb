#!/usr/bin/env ruby


$:.unshift File.dirname(__FILE__)

require 'lib/ariia'
require 'json'

config_options = JSON.parse File.read('config.json')

watcher = Ariia::Watch.new

config_options.each do |config|
  puts config
  watcher.watch config['local_path'], config['remote']['user'], config['remote']['server'], config['remote']['path']
end

watcher.run
