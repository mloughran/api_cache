class APICache
  class Error < RuntimeError; end
  class Invalid <  RuntimeError; end
  
  class << self
    attr_accessor :cache
  end
  
  # Initializes the cache
  def self.start
    APICache.cache = APICache::MemoryStore.new
  end
  
  # Raises an APICache::Error if it can't get a value. You should rescue this.
  # 
  # Optionally call with a block. The value of the block is then used to 
  # set the cache rather than calling the url. Use it for example if you need
  # to make another type of request, catch custom error codes etc. To signal
  # that the call failed just throw :invalid - the value will then not be
  # cached and the api will not be called again for options[:timeout] seconds.
  # 
  # For example:
  # [Add example here]
  def self.get(url, options = {}, &block)
    options = {
      :cache => 600,    # 10 minutes  After this time fetch new value
      :valid => 86400,  # 1 day       Expire even if not fetched new data
      :period => 60,    # 1 minute    Don't call API more frequently than this
      :timeout => 5     # 5 seconds   Timeout to wait for response
    }.merge(options)
    
    if cache.exists?(url) && !cache.expired?(url, options[:cache])
      # Cache is populated and not expired
      cache.get(url)
    else
      # Cache is not populated or is expired
      begin
        r = Timeout::timeout(options[:timeout]) do
          if block_given?
            # This should raise APICache::Invalid if it is not correct
            yield
          else
            r = Net::HTTP.get_response(URI.parse(url)).body
            # TODO: Check that it's a 200 response
          end
        end
        cache.set(url, r)
      rescue Timeout::Error, APICache::Invalid
        if cache.exists?(url)
          cache.get(url)
        else
          raise APICache::Error
        end
      end
    end 
  end
end

require 'api_cache/memory_store'
