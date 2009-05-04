class APICache
  class MemoryStore < APICache::AbstractStore
    def initialize
      APICache.logger.log "Using memory store"
      @cache = {}
      true
    end

    def set(key, value)
      APICache.logger.log("cache: set (#{key})")
      @cache[key] = [Time.now, value]
      true
    end

    def get(key)
      data = @cache[key][1]
      APICache.logger.log("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
      data
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
