class APICache
  # A null store for environments where caching may be undesirable, such as
  # testing.
  class NullStore < APICache::AbstractStore
    def initialize
    end
    
    def exists?(key)
      false
    end

    def set(key, value)
      true
    end

    def delete(key)
    end

    def expired?(key, timeout)
      true
    end
  end
end
