---
layout: default
---

API Cache allows advanced caching of APIs.

Install
-------

    $ sudo gem install mloughran-api_cache

Highlights
----------

This is how you access the twitter public timeline if you need your site to stay up, regardless of what twitter does.

    APICache.get("http://twitter.com/statuses/public_timeline.rss")

It will fetch a new version once the cached version is 10 minutes old, keep the old version for a day just in case, and never contact twitter more than once a minute. Of course all these numbers are configurable.

This does the same thing; adding caching to an otherwise excellent Flickr library.

    APICache.get("my_photos") do
      SuperFlickLibWhichDoesntDoCaching.get_my_photos
    end

See the [README](http://github.com/mloughran/api_cache/blob/master/README.rdoc) for a proper introduction.
