$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "api_cache"
require "spec"

APICache.logger.level = Logger::FATAL
