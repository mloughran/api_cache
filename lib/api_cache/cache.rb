# Cache performs calculations relating to the status of items stored in the
# cache and delegates storage to the various cache stores.
require 'digest/md5'
class APICache::Cache
  attr_accessor :store
  def initialize(store)
    @store = store.send(:new)
  end
  
  # Returns one of the following options depending on the state of the key:
  # 
  # * :current (key has been set recently)
  # * :refetch (data should be refetched but is still available for use)
  # * :invalid (data is too old to be useful)
  # * :missing (do data for this key)
  def state(key, refetch_time, invalid_time)
    if @store.exists?(encode(key))
      if !@store.expired?(encode(key), refetch_time)
        :current
      elsif (invalid_time == :forever) || !@store.expired?(encode(key), invalid_time)
        :refetch
      else
        :invalid
      end
    else
      :missing
    end
  end
  
  def get(key)
    @store.get(encode(key))
  end
  
  def set(key, value)
    @store.set(encode(key), value)
    true
  end
  def encode(key)
    Digest::MD5.hexdigest key
  end
end
