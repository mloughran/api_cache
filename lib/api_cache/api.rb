require 'net/http'

class APICache
  # Wraps up querying the API.
  # 
  # Ensures that the API is not called more frequently than every +period+ seconds, and times out API requests after +timeout+ seconds.
  #
  class API
    # Takes the following options
    #
    # period:: Maximum frequency to call the API
    # timeout:: Timeout when calling api (either to the proviced url or
    #           excecuting the passed block)
    # block:: If passed then the block is excecuted instead of HTTP GET 
    #         against the provided key
    #
    def initialize(key, options, &block)
      @key, @block = key, block
      @timeout = options[:timeout]
      @period = options[:period]
    end

    # Checks whether the API can be queried (i.e. whether :period has passed
    # since the last query to the API).
    #
    # If :period is 0 then there is no limit on how frequently queries can
    # be made to the API.
    #
    def queryable?
      if previously_queried?
        if Time.now - queried_at > @period
          APICache.logger.debug "Queryable: true - retry_time has passed"
          true
        else
          APICache.logger.debug "Queryable: false - queried too recently"
          false
        end
      else
        APICache.logger.debug "Queryable: true - never used API before"
        true
      end
    end

    # Fetch data from the API.
    #
    # If no block is given then the key is assumed to be a URL and which will
    # be queried expecting a 200 response. Otherwise the return value of the
    # block will be used.
    #
    # If the block is unable to fetch the value from the API it should raise
    # APICache::Invalid.
    #
    def get
      APICache.logger.debug "Fetching data from the API"
      set_queried_at
      Timeout::timeout(@timeout) do
        if @block
          # This should raise APICache::Invalid if it is not correct
          @block.call
        else
          get_key_via_http
        end
      end
    rescue Timeout::Error, APICache::Invalid => e
      raise APICache::CannotFetch, e.message
    end

    private

    def get_key_via_http
      response = redirecting_get(@key)
      case response
      when Net::HTTPSuccess
        # 2xx response code
        response.body
      else
        raise APICache::Invalid, "Invalid http response: #{response.code}"
      end
    end

    def redirecting_get(url)
      r = Net::HTTP.get_response(URI.parse(url))
      r.header['location'] ? redirecting_get(r.header['location']) : r
    end

    def previously_queried?
      APICache.store.exists?("#{@key}_queried_at")
    end
    
    def queried_at
      APICache.store.get("#{@key}_queried_at")
    end
    
    def set_queried_at
      APICache.store.set("#{@key}_queried_at", Time.now)
    end
  end
end
