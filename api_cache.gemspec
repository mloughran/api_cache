# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "api_cache"
  s.version     = "0.2.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martyn Loughran"]
  s.email       = ["me@mloughran.com"]
  s.homepage    = "http://mloughran.github.com/api_cache/"
  s.summary     = %q{API Cache allows advanced caching of APIs}
  s.description = %q{APICache allows any API client library to be easily wrapped with a robust caching layer. It supports caching (obviously), serving stale data and limits on the number of API calls. It's also got a handy syntax if all you want to do is cache a bothersome url.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rspec', "~> 2.7")
  s.add_development_dependency('webmock')
  s.add_development_dependency('rake')
  s.add_development_dependency('moneta', "~> 0.6.0")
  s.add_development_dependency('dalli')
  s.add_development_dependency('memcache-client')
end
