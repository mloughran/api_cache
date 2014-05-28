require 'api_cache'
require 'byebug'
require 'rspec'
require 'webmock/rspec'

$:.push File.join(File.dirname(__FILE__), '..', 'lib')

APICache.logger.level = Logger::FATAL
