class APICache::MemoryStore
  def initialize
    puts "Init cache"
    @cache = {}
  end

  def expired?(key, timeout)
    Time.now - created(key) > timeout
  end

  def set(key, value)
    puts "Setting the cache"
    @cache[key] = [Time.now, value]
    value
  end

  def get(key)
    puts "Serving from cache"
    @cache[key][1]
  end

  def exists?(key)
    !@cache[key].nil?
  end

  private

  def created(key)
    @cache[key][0]
  end
end
