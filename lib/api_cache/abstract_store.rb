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

    # created_at returns the time when the key was last set
    def created_at(key)
      raise "Method not implemented. Called abstract class."
    end

    # expired? returns true if the given timeout has passed since the key was
    # set. It has nothing to say about the existence or otherwise of said key.
    def expired?(key, timeout)
      if (created_at = created_at(key))
        Time.now - created_at > timeout
      else
        # If the created_at data is missing assume expired
        true
      end
    end
  end
end
