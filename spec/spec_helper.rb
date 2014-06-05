require "api_cache"
require "rspec"
require "webmock/rspec"

$LOAD_PATH.push File.join(File.dirname(__FILE__), "..", "lib")

APICache.logger.level = Logger::FATAL
