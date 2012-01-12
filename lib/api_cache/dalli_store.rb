class APICache
  class DalliStore < APICache::AbstractStore
    def initialize(store)
      @dalli = store
    end

    # Set value. Returns true if success.
    def set(key, value)
      @dalli.set(key, value)
      @dalli.set("#{key}_created_at", Time.now)
      true
    end

    # Get value.
    def get(key)
      @dalli.get(key)
    end

    # Delete value.
    def delete(key)
      @dalli.delete(key)
    end

    # Does a given key exist in the cache?
    def exists?(key)
      !get(key).nil?
    end

    # Has a given time passed since the key was set?
    def expired?(key, timeout)
      Time.now - @dalli.get("#{key}_created_at") > timeout
    end
  end
end
