require "spec"
require "fakeweb"

$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require "api_cache"

APICache.logger.level = Logger::FATAL
