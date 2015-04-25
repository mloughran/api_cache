# APICache (aka api_cache)

APICache allows any API client library to be easily wrapped with a robust caching layer. It supports caching (obviously), serving stale data and limits on the number of API calls. It's also got a handy syntax if all you want to do is cache a bothersome url.

## For the impatient

    # Install
    sudo gem install api_cache -s http://gemcutter.org
    
    # Require
    require 'rubygems'
    require 'api_cache'
    
    # Use
    APICache.get("http://twitter.com/statuses/public_timeline.rss")
    
    # Use a proper store
    require 'moneta'
    APICache.store = Moneta.new(:Memcached)
    
    # Wrap an API, and handle the failure case
    
    APICache.get("my_albums", :fail => []) do
      FlickrRb.get_all_sets
    end

## Heroku + memcache

Heroku memcache add-on users can use APICache with the [Dalli](https://github.com/mperham/dalli) gem, no manual configuration is required as Dalli automatically picks up the appropriate environment variables.

    require 'api_cache'
    require 'dalli'

    APICache.store = APICache::DalliStore.new(Dalli::Client.new)

## The longer version

You want to use the Twitter API but you don't want to die?

    APICache.get("http://twitter.com/statuses/public_timeline.rss")

This works better than a standard HTTP get because you get the following functionality for free:

* Cached response returned for 10 minutes
* Stale response returned for a day if twitter is down
* Limited to attempt a connection at most once a minute

To understand what `APICache` does here's an example: Given cached data less than 10 minutes old, it returns that. Otherwise, assuming it didn't try to request the URL within the last minute (to avoid the rate limit), it makes a get request to the supplied url. If the Twitter API timeouts or doesn't return a 2xx code (very likely) we're still fine: it just returns the last data fetched (as long as it's less than a day old). In the exceptional case that all is lost and no data can be returned, a subclass of `APICache::APICacheError` is raised which you're responsible for rescuing.

Assuming that you don't care whether it was a timeout error or an invalid response (for example) you could do this:

    begin
      APICache.get("http://twitter.com/statuses/public_timeline.rss")
    rescue APICache::APICacheError
      "Fail Whale"
    end

However there's an easier way if you don't care exactly why the API call failed. You can just pass the :fail parameter (procs are accepted too) and all exceptions will be rescued for you. So this is exactly equivalent:

    APICache.get("http://twitter.com/statuses/public_timeline.rss", {
      :fail => "Fail Whale"
    })

The real value however is not caching HTTP calls, but allowing caching functionality to be easily added to existing API client gems, or in fact any arbitrary code which is either slow or not guaranteed to succeed every time.

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
          raise APICache::InvalidResponse
        end
      end
    end

The first argument to `APICache.get` is now assumed to be a unique key rather than a URL. As you'd expect, the block will only be called if the request cannot be fulfilled by the cache. Throwing any exception signals to `APICache` that the request was not successful, should not be cached, and a cached value should be returned if available. If a cached value is not available then the exception will be re-raised for you to handle.

You can send any of the following options to `APICache.get(url, options = {}, &block)`. These are the default values (times are all in seconds):

    {
      :cache => 600,    # 10 minutes  After this time fetch new data
      :valid => 86400,  # 1 day       Maximum time to use old data
                        #             :forever is a valid option
      :period => 60,    # 1 minute    Maximum frequency to call API
      :timeout => 5     # 5 seconds   API response timeout
      :fail =>          # Value returned instead of exception on failure
    }

Before using the APICache you should set the cache to use. By default an in memory hash is used - obviously not a great idea. Thankfully APICache can use any moneta store, so for example if you wanted to use memcache you'd do this:

    APICache.store = Moneta.new(:Memcached)

Please be liberal with the github issue tracker, more so with pull requests, or drop me a mail to me [at] mloughran [dot] com. I'd love to hear from you.

## Contributing

Please open an issue to discuss any major changes, and add specs.

Tests require running a local memcached server, and are started thus:

    bundle install
    bundle exec rake

## Copyright

Copyright (c) 2008-2011 Martyn Loughran. See LICENSE for details.
