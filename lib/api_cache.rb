class APICache
  class NotAvailableError < RuntimeError; end
  class Invalid <  RuntimeError; end
  class CannotFetch < RuntimeError; end
  
  class << self
    attr_accessor :store
    attr_accessor :api
    attr_accessor :logger
  end
  
  # Initializes the cache
  def self.start(store = nil, logger = nil)
    APICache.logger = logger || APICache::Logger.new
    APICache::Cache.store = (store || APICache::MemcacheStore).new
  end
  
  # Raises an APICache::NotAvailableError if it can't get a value. You should 
  # rescue this if your application code.
  # 
  # Optionally call with a block. The value of the block is then used to 
  # set the cache rather than calling the url. Use it for example if you need
  # to make another type of request, catch custom error codes etc. To signal
  # that the call failed just raise APICache::Invalid - the value will then 
  # not be cached and the api will not be called again for options[:timeout] 
  # seconds. If an old value is available in the cache then it will be used.
  # 
  # For example:
  #   APICache.get("http://twitter.com/statuses/user_timeline/6869822.atom")
  # 
  #   APICache.get \
  #     "http://twitter.com/statuses/user_timeline/6869822.atom",
  #     :cache => 60, :valid => 600
  # 
  def self.get(key, options = {}, &block)
    options = {
      :cache => 600,    # 10 minutes  After this time fetch new data
      :valid => 86400,  # 1 day       Maximum time to use old data
                        #             :forever is a valid option
      :period => 60,    # 1 minute    Maximum frequency to call API
      :timeout => 5     # 5 seconds   API response timeout
    }.merge(options)
    
    cache = APICache::Cache.new(key, {
      :cache => options[:cache], 
      :valid => options[:valid]
    })
    
    api = APICache::API.new(key, {
      :period => options[:period], 
      :timeout => options[:timeout]
    }, &block)
    
    cache_state = cache.state
    
    if cache_state == :current
      cache.get
    else
      begin
        raise APICache::CannotFetch unless api.queryable?
        value = api.get
        cache.set(value)
        value
      rescue APICache::CannotFetch => e
        APICache.logger.log "Failed to fetch new data from API because " \
          "#{e.class}: #{e.message}"
        if cache_state == :refetch
          cache.get
        else
          APICache.logger.log "Data not available in the cache or from API"
          raise APICache::NotAvailableError, e.message
        end
      end
    end
  end
end

require 'api_cache/cache'
require 'api_cache/api'
require 'api_cache/logger'

APICache.autoload 'AbstractStore', 'api_cache/abstract_store'
APICache.autoload 'MemoryStore', 'api_cache/memory_store'
APICache.autoload 'MemcacheStore', 'api_cache/memcache_store'