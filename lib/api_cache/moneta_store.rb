class APICache
  class MonetaStore < APICache::AbstractStore
    def initialize(store)
      @moneta = store
    end

    # Set value. Returns true if success.
    def set(key, value)
      @moneta[key] = value
      @moneta["#{key}_created_at"] = Time.now
      true
    end

    # Get value.
    def get(key)
      @moneta[key]
    end

    # Delete value.
    def delete(key)
      @moneta.delete(key)
    end

    # Does a given key exist in the cache?
    def exists?(key)
      @moneta.key?(key)
    end

    # Has a given time passed since the key was set?
    def expired?(key, timeout)
      Time.now - @moneta["#{key}_created_at"] > timeout
    end
  end
end
