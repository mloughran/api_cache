require 'net/http'

class APICache
  # Wraps up querying the API.
  #
  # Ensures that the API is not called more frequently than every +period+
  # seconds, and times out API requests after +timeout+ seconds.
  #
  class API
    # Takes the following options
    #
    # period:: Maximum frequency to call the API. If set to 0 then there is no
    #          limit on how frequently queries can be made to the API.
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

    # Fetch data from the API.
    #
    # If no block is given then the key is assumed to be a URL and which will
    # be queried expecting a 200 response. Otherwise the return value of the
    # block will be used.
    #
    # This method can raise Timeout::Error, APICache::InvalidResponse, or any
    # exception raised in the block passed to APICache.get
    #
    def get
      check_queryable!
      APICache.logger.debug "APICache #{@key}: Calling API"
      set_queried_at
      Timeout::timeout(@timeout) do
        if @block
          # If this call raises an error then the response is not cached
          @block.call
        else
          get_key_via_http
        end
      end
    rescue Timeout::Error => e
      raise APICache::TimeoutError, "APICache #{@key}: Request timed out (timeout #{@timeout}s)"
    end

    private

    def get_key_via_http
      response = redirecting_get(@key)
      case response
      when Net::HTTPSuccess
        # 2xx response code
        response.body
      else
        raise APICache::InvalidResponse, "APICache #{@key}: InvalidResponse http response: #{response.code}"
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
           Net::ProtocolError, Errno::ECONNREFUSED, SocketError => e
      raise APICache::InvalidResponse, "APICache #{@key}: Net::HTTP error (#{e.message} - #{e.class})"
    end

    def redirecting_get(url)
      r = Net::HTTP.get_response(URI.parse(url))
      r.header['location'] ? redirecting_get(r.header['location']) : r
    end

    # Checks whether the API can be queried (i.e. whether :period has passed
    # since the last query to the API).
    #
    def check_queryable!
      if previously_queried?
        if Time.now - queried_at > @period
          APICache.logger.debug "APICache #{@key}: Is queryable - retry_time has passed"
        else
          APICache.logger.debug "APICache #{@key}: Not queryable - queried too recently"
          raise APICache::CannotFetch,
            "Cannot fetch #{@key}: queried too recently"
        end
      else
        APICache.logger.debug "APICache #{@key}: Is queryable - first query"
      end
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
