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

    def created_at(key)
      @moneta["#{key}_created_at"]
    end
  end
end
