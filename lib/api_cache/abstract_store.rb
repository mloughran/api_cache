class APICache
  class AbstractStore
    private

    method_not_implemented_message = "Method not implemented. Called abstract class."

    def initialize
      raise method_not_implemented_message
    end

    # Set value. Returns true if success.
    def set(key, value)
      raise method_not_implemented_message
    end

    # Get value.
    def get(key)
      raise method_not_implemented_message
    end

    # Delete the given key. The return value is not used.
    def delete(key)
      raise method_not_implemented_message
    end

    # Does a given key exist in the cache?
    def exists?(key)
      raise method_not_implemented_message
    end

    # created_at returns the time when the key was last set
    def created_at(key)
      raise method_not_implemented_message
    end

    # Set a key's time to live in seconds
    def expire(key, seconds)
      raise method_not_implemented_message
    end

    # returns the number of keys in the store
    def count
      raise method_not_implemented_message
    end

    # finds all keys matching the given pattern
    def keys(pattern = "*")
      raise method_not_implemented_message
    end

    # deletes all keys
    def clear
      raise method_not_implemented_message
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
