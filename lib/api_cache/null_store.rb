class APICache
  # A null store for environments where caching may be undesirable, such as
  # testing.
  class NullStore < APICache::AbstractStore
    def initialize
    end

    def set(key, value)
      true
    end

    def get(key)
      nil
    end

    def delete(key)
    end

    def exists?(key)
      false
    end

    def created_at(key)
      nil
    end
  end
end
