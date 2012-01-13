require 'digest/md5'

class APICache
  # Cache performs calculations relating to the status of items stored in the
  # cache and delegates storage to the various cache stores.
  #
  class Cache
    # Takes the following options
    #
    # cache:: Length of time to cache before re-requesting
    # valid:: Length of time to consider data still valid if API cannot be
    #         fetched - :forever is a valid option.
    #
    def initialize(key, options)
      @key = key
      @cache = options[:cache]
      @valid = options[:valid]
    end

    # Returns one of the following options depending on the state of the key:
    #
    # * :current (key has been set recently)
    # * :refetch (data should be refetched but is still available for use)
    # * :invalid (data is too old to be useful)
    # * :missing (do data for this key)
    #
    def state
      if store.exists?(hash)
        if !store.expired?(hash, @cache)
          :current
        elsif (@valid == :forever) || !store.expired?(hash, @valid)
          :refetch
        else
          :invalid
        end
      else
        :missing
      end
    end

    def get
      store.get(hash)
    end

    def set(value)
      store.set(hash, value)
      true
    end

    def delete
      store.delete(hash)
    end

    private

    def hash
      Digest::MD5.hexdigest @key
    end

    def store
      APICache.store
    end
  end
end
