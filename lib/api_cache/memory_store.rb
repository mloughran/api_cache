class APICache::MemoryStore
  def initialize
    puts "Init cache"
    @cache = {}
  end

  def expired?(name, timeout)
    Time.now - created(name) > timeout
  end

  def set(name, value)
    puts "Setting the cache"
    @cache[name] = [Time.now, value]
    value
  end

  def get(name)
    puts "Serving from cache"
    @cache[name][1]
  end

  def exists?(name)
    !@cache[name].nil?
  end

  private

  def created(name)
    @cache[name][0]
  end
end
