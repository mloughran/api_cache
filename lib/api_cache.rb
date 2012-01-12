require 'logger'

# Contains the complete public API for APICache.
#
# See APICache.get method and the README file.
#
# Before using APICache you should set the store to use using
# APICache.store=. For convenience, when no store is set an in memory store
# will be used (and a warning will be logged).
#
class APICache
  class APICacheError < RuntimeError; end
  class NotAvailableError < APICacheError; end
  class TimeoutError < NotAvailableError; end
  class InvalidResponse <  NotAvailableError; end
  class CannotFetch < NotAvailableError; end

  class << self
    attr_accessor :logger
    attr_accessor :store

    def logger # :nodoc:
      @logger ||= begin
        log = Logger.new(STDOUT)
        log.level = Logger::INFO
        log
      end
    end

    # Set the logger to use. If not set, <tt>Logger.new(STDOUT)</tt> will be
    # used.
    #
    def logger=(logger)
      @logger = logger
    end

    def store # :nodoc:
      @store ||= begin
        APICache.logger.warn("Using in memory store")
        APICache::MemoryStore.new
      end
    end

    # Set the cache store to use. This should either be an instance of a
    # moneta store or a subclass of APICache::AbstractStore. Moneta is
    # recommended.
    #
    def store=(store)
      @store = begin
        if store.class < APICache::AbstractStore
          store
        elsif store.class.to_s =~ /Moneta/
          MonetaStore.new(store)
        elsif store.nil?
          nil
        else
          raise ArgumentError, "Please supply an instance of either a moneta store or a subclass of APICache::AbstractStore"
        end
      end
    end
  end

  # Optionally call with a block. The value of the block is then used to
  # set the cache rather than calling the url. Use it for example if you need
  # to make another type of request, catch custom error codes etc. To signal
  # that the call failed just raise any exception - the value will then
  # not be cached and the api will not be called again for options[:timeout]
  # seconds. If an old value is available in the cache then it will be
  # returned.
  #
  # An exception will be raised if the API cannot be fetched and the request
  # cannot be served by the cache. This will either be a subclass of
  # APICache::Error or an exception raised by the provided block.
  #
  # For example:
  #   APICache.get("http://twitter.com/statuses/user_timeline/6869822.atom")
  #
  #   APICache.get \
  #     "http://twitter.com/statuses/user_timeline/6869822.atom",
  #     :cache => 60, :valid => 600
  #
  def self.get(key, options = {}, &block)
    options = {
      :cache => 600,    # 10 minutes  After this time fetch new data
      :valid => 86400,  # 1 day       Maximum time to use old data
      #             :forever is a valid option
      :period => 60,    # 1 minute    Maximum frequency to call API
      :timeout => 5     # 5 seconds   API response timeout
    }.merge(options)

    cache = APICache::Cache.new(key, {
      :cache => options[:cache],
      :valid => options[:valid]
    })

    api = APICache::API.new(key, {
      :period => options[:period],
      :timeout => options[:timeout]
    }, &block)

    cache_state = cache.state

    if cache_state == :current
      APICache.logger.debug "APICache #{@key}: Returning from cache"
      cache.get
    else
      begin
        value = api.get
        cache.set(value)
        value
      rescue => e
        APICache.logger.info "APICache #{key}: Exception raised (#{e.message} - #{e.class})" \

        # No point outputting backgraces for internal APICache errors
        APICache.logger.debug "Backtrace:\n#{e.backtrace.join("\n")}" unless e.kind_of?(APICacheError)

        if cache_state == :refetch
          cache.get
        else
          APICache.logger.warn "APICache #{key}: Data not available in the cache or from API"
          if options.has_key?(:fail)
            fail = options[:fail]
            fail.respond_to?(:call) ? fail.call : fail
          else
            raise e
          end
        end
      end
    end
  end

  # Manually delete data from the cache.
  #
  def self.delete(key)
    APICache::Cache.new(key, {}).delete
  end

end

require 'api_cache/cache'
require 'api_cache/api'

APICache.autoload 'AbstractStore', 'api_cache/abstract_store'
APICache.autoload 'DalliStore', 'api_cache/dalli_store'
APICache.autoload 'MemoryStore', 'api_cache/memory_store'
APICache.autoload 'MonetaStore', 'api_cache/moneta_store'
APICache.autoload 'NullStore', 'api_cache/null_store'
