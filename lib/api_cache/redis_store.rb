class APICache
  class RedisStore < APICache::AbstractStore
    def initialize(store)
      @redis = store
    end

    # Set value. Returns true if success.
    def set(key, value)
      @redis.set(key, value)
      @redis["#{key}_created_at"] = Time.now
      true
    end

    # Get value.
    def get(key)
      @redis.get(key)
    end

    # Delete value.
    def delete(key)
      @redis.del(key)
    end

    # Does a given key exist in the cache?
    def exists?(key)
      @redis.exists(key)
    end

    # Set a key's time to live in seconds
    def expire(key, seconds)
      @redis.expire(key, seconds)
    end

    # Has a given time passed since the key was set? 
    def expired?(key, timeout)
      @redis.ttl(key) <= 0
    end

  end
end
