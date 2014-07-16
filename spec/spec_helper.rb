require "rspec"
require 'webmock/rspec'

$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require "api_cache"

APICache.logger.level = Logger::FATAL

require "shared_store_specs"
