require 'net/http'

# This class wraps up querying the API and remembers when each API was 
# last queried in case there is a limit to the number that can be made.
class APICache::API
  def initialize
    @query_times = {}
  end
  
  # Checks whether the API can be queried (i.e. whether retry_time has passed
  # since the last query to the API).
  # 
  # If retry_time is 0 then there is no limit on how frequently queries can
  # be made to the API.
  def queryable?(key, retry_time)
    if @query_times[key]
      if Time.now - @query_times[key] > retry_time
        # puts "Queryable: true - retry_time has passed"
        true
      else
        # puts "Queryable: false - queried too recently"
        false
      end
    else
      # puts "Queryable: true - never used API before"
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
  def get(key, timeout, &block)
    # puts "Fetching data from the API"
    @query_times[key] = Time.now
    Timeout::timeout(timeout) do
      if block_given?
        # This should raise APICache::Invalid if it is not correct
        yield
      else
        get_via_http(key, timeout)
      end
    end
  rescue Timeout::Error, APICache::Invalid
    raise APICache::CannotFetch
  end
  
private
  
  def get_via_http(key, timeout)
    response = Net::HTTP.get_response(URI.parse(key))
    case response
    when Net::HTTPSuccess
      # 2xx response code
      response.body
    else
      raise APICache::Invalid
    end
  end
end
