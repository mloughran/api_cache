require 'net/http'

# This class wraps up querying the API and remembers when each API was
# last queried in case there is a limit to the number that can be made.
#
class APICache::API
  @query_times = {}
  class << self
    attr_reader :query_times
  end
  
  # Takes the following options
  # 
  # period:: Maximum frequency to call the API
  # timeout:: Timeout when calling api (either to the proviced url or 
  #           excecuting the passed block)
  # block:: If passed then the block is excecuted instead of HTTP GET against 
  #         the provided key
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
    if query_times[@key]
      if Time.now - query_times[@key] > @period
        APICache.logger.log "Queryable: true - retry_time has passed"
        true
      else
        APICache.logger.log "Queryable: false - queried too recently"
        false
      end
    else
      APICache.logger.log "Queryable: true - never used API before"
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
    APICache.logger.log "Fetching data from the API"
    query_times[@key] = Time.now
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
  
  def query_times
    self.class.query_times
  end
end
