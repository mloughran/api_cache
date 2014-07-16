class APICache
  class MemoryStore < APICache::AbstractStore
    def initialize(cache = {})
      APICache.logger.debug "Using memory store"
      @cache = cache
      true
    end

    def set(key, value)
      APICache.logger.debug("cache: set (#{key})")
      @cache[key] = [Time.now, value]
      true
    end

    def get(key)
      data = exists?(key) ? @cache[key][1] : nil
      APICache.logger.debug("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
      data
    end

    def delete(key)
      @cache.delete(key)
    end

    def exists?(key)
      !@cache[key].nil?
    end

    def created_at(key)
      @cache[key] && @cache[key][0]
    end
  end
end
