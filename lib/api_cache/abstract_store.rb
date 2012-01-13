class APICache
  class AbstractStore
    def initialize
      raise "Method not implemented. Called abstract class."
    end

    # Set value. Returns true if success.
    def set(key, value)
      raise "Method not implemented. Called abstract class."
    end

    # Get value.
    def get(key)
      raise "Method not implemented. Called abstract class."
    end

    # Delete value.
    def delete(key)
      raise "Method not implemented. Called abstract class."
    end

    # Does a given key exist in the cache?
    def exists?(key)
      raise "Method not implemented. Called abstract class."
    end

    # Has a given time passed since the key was set?
    def expired?(key, timeout)
      raise "Method not implemented. Called abstract class."
    end
  end
end
