# Changelog

## 0.3.0 – 2014-07-16

* [NEW] Allow keys to be deleted [Doug Puchalski]
* [UPDATED] Updated Moneta dependency - works with 0.7.x & 0.8.x
* [FIX] Fixed long standing bug in the case that the `created_at` key was evicted before the data key (for example when using memcached)
