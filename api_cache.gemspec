# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{api_cache}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martyn Loughran"]
  s.date = %q{2009-08-21}
  s.description = %q{APICache allows any API client library to be easily wrapped with a robust caching layer. It supports caching (obviously), serving stale data and limits on the number of API calls. It's also got a handy syntax if all you want to do is cache a bothersome url.}
  s.email = %q{me@mloughran.com}
  s.files = ["README.rdoc", "VERSION.yml", "lib/api_cache", "lib/api_cache/abstract_store.rb", "lib/api_cache/api.rb", "lib/api_cache/cache.rb", "lib/api_cache/memory_store.rb", "lib/api_cache/moneta_store.rb", "lib/api_cache.rb", "spec/api_cache_spec.rb", "spec/api_spec.rb", "spec/cache_spec.rb", "spec/integration_spec.rb", "spec/monteta_store_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://mloughran.github.com/api_cache/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{API Cache allows advanced caching of APIs}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
  end
end
