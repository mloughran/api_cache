require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

PLUGIN = "api_cache"
NAME = "api_cache"
GEM_VERSION = "0.0.2"
AUTHOR = "Martyn Loughran"
EMAIL = "me@mloughran.com"
HOMEPAGE = "http://github.com/mloughran/api_cache/"
SUMMARY = "Library to handle caching external API calls"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = PLUGIN
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the plugin locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{NAME}-#{GEM_VERSION} --no-update-sources}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
