---
layout: default
---

APICache allows any API client library to be easily wrapped with a robust caching layer. It supports caching (obviously), serving stale data and limits on the number of API calls. It’s also got a handy syntax if all you want to do is cache a bothersome url.

Install
-------
    
    $ sudo gem install api_cache -s http://gemcutter.org

Quick intro
-----------

This is how you access the twitter public timeline if you need your site to stay up, regardless of what twitter does.

    require 'rubygems'
    require 'api_cache'
    APICache.get("http://twitter.com/statuses/public_timeline.rss")

It will fetch a new version once the cached version is 10 minutes old, keep the old version for a day just in case, and never contact twitter more than once a minute. Of course all these numbers are configurable.

APICache uses moneta so you can use any key-value store you like.
    
    require 'moneta/memcache'
    APICache.store = Moneta::Memcache.new(:server => "localhost")

This adds caching to an otherwise excellent Flickr library.

    APICache.get("my_photos") do
      SuperFlickLibWhichDoesntDoCaching.get_my_photos
    end

See the [README](http://github.com/mloughran/api_cache/blob/master/README.rdoc) for a proper introduction.
