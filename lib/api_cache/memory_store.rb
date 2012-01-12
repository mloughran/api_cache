class APICache
  class MemoryStore < APICache::AbstractStore
    def initialize
      APICache.logger.debug "Using memory store"
      @cache = {}
      true
    end

    def set(key, value)
      APICache.logger.debug("cache: set (#{key})")
      @cache[key] = [Time.now, value]
      true
    end

    def get(key)
      data = @cache[key][1]
      APICache.logger.debug("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
      data
    end

    def delete(key)
      @cache.delete(key)
    end

    def exists?(key)
      !@cache[key].nil?
    end

    def expired?(key, timeout)
      Time.now - created(key) > timeout
    end

    private

    def created(key)
      @cache[key][0]
    end
  end
end
