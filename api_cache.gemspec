# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{api_cache}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martyn Loughran"]
  s.date = %q{2009-03-30}
  s.description = %q{Library to handle caching external API calls}
  s.email = %q{me@mloughran.com}
  s.files = ["README.markdown", "VERSION.yml", "lib/api_cache", "lib/api_cache/abstract_store.rb", "lib/api_cache/api.rb", "lib/api_cache/cache.rb", "lib/api_cache/logger.rb", "lib/api_cache/memcache_store.rb", "lib/api_cache/memory_store.rb", "lib/api_cache.rb", "spec/api_cache_spec.rb", "spec/api_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mloughran/api_cache}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Library to handle caching external API calls}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
