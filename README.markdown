api_cache
=========
You want to use the Twitter API but you don't want to die? I have the solution to API caching:

    APICache.get("http://twitter.com/statuses/public_timeline.rss")

You get the following functionality for free:

* New data every 10 minutes
* If the twitter API dies then keep using the last data received for a day. Then assume it's invalid and announce that Twitter has FAILED (optional).
* Don't hit the rate limit (70 requests per 60 minutes)

So what exactly does `APICache` do? Given cached data younger than 10 minutes old, it return that. Otherwise, assuming we didn't try to request the URL within the last minute (to avoid the rate limit), makes a get request to the Twitter API. If it timeouts or doesn't return a 2xx code (very likely) we're still fine: just returns the last data fetched (as long as it's less than a day old). In the exceptional case all is lost and no data can be returned, raise an `APICache::NotAvailableError` exception. You're responsible for catching that and complaining bitterly to the internet.

All very simple. What if you need to do something more complicated? Say you need authentication or the silly API you're using doesn't follow a nice convention of returning 2xx for success. Then you need a block:

    APICache.get('twitter_replies', :cache => 3600) do
      Net::HTTP.start('twitter.com') do |http|
        req = Net::HTTP::Get.new('/statuses/replies.xml')
        req.basic_auth 'username', 'password'
        response = http.request(req)
        case response
        when Net::HTTPSuccess
          # 2xx response code
          response.body
        else
          raise APICache::Invalid
        end
      end
    end

All the caching is still handled for you. If you supply a block then the first argument to `APICache.get` is assumed to be a unique key rather than a URL. Throwing `APICache::Invalid` signals to `APICache` that the request was not successful.

An options hash that allows you to customize the following. These are the default values (all in seconds):

    {
      :cache => 600,    # 10 minutes  After this time fetch new data
      :valid => 86400,  # 1 day       After this time discard old data
      :period => 60,    # 1 minute    Maximum frequency to call API
      :timeout => 5     # 5 seconds   API response timeout
    }

The first 3 options correspond to the 3 requirements above. The `:timeout` allows you to specify how long to wait for a response from the API before giving up. Currently no retries occur. This doesn't matter since we will always have some data to display except for the case where we haven't received any data for longer than `:valid`. If you specify `{:valid => :forever}` then the old data will keep getting supplied as long as it is available in the store.

Before using the APICache you need to initialize the caches. In merb, for example, put this in your `init.rb`:

    APICache.start

Currently there are two stores available: `MemcacheStore` and `MemoryStore`. `MemcacheStore` is the default but if you'd like to use `MemoryStore`, or another store - see `AbstractStore`, just supply it to the start method:

    APICache.start(APICache::MemoryStore)

I suppose you'll want to get your hands on this magic. For now just grab the source from [github](http://github.com/mloughran/api_cache/tree/master) and `rake install`. I'll get a gem sorted soon.
