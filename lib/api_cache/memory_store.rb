class APICache::MemoryStore < APICache::AbstractStore
  def initialize
    puts "Init cache"
    @cache = {}
    true
  end

  def set(key, value)
    puts "Setting the cache"
    @cache[key] = [Time.now, value]
    true
  end

  def get(key)
    puts "Serving from cache"
    @cache[key][1]
  end

  def exists?(key)
    !@cache[key].nil?
  end
  
  def expired?(key, timeout)
    Time.now - created(key) > timeout
  end

  private

  def created(key)
    @cache[key][0]
  end
end
