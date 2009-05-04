require 'memcache'

class APICache
  class MemcacheStore < APICache::AbstractStore
    class NotReady < Exception #:nodoc:
      def initialize
        super("Memcache server is not ready")
      end
    end

    class NotDefined < Exception #:nodoc:
      def initialize
        super("Memcache is not defined")
      end
    end

    def initialize
      APICache.logger.debug "Using memcached store"
      namespace = 'api_cache'
      host = '127.0.0.1:11211'
      @memcache = MemCache.new(host, {:namespace => namespace})
      raise NotReady unless @memcache.active?
      true
      # rescue NameError
      #   raise NotDefined
    end

    def set(key, data)
      @memcache.set(key, data)
      @memcache.set("#{key}_created_at", Time.now)
      APICache.logger.debug("cache: set (#{key})")
      true
    end

    def get(key)
      data = @memcache.get(key)
      APICache.logger.debug("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
      data
    end

    def exists?(key)
      # TODO: inefficient - is there a better way?
      !@memcache.get(key).nil?
    end

    def expired?(key, timeout)
      Time.now - created(key) > timeout
    end

    private

    def created(key)
      @memcache.get("#{key}_created_at")
    end
  end
end
