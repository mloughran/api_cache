require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "api_cache"
    s.summary = %Q{API Cache allows advanced caching of APIs}
    s.email = "me@mloughran.com"
    s.homepage = "http://mloughran.github.com/api_cache/"
    s.description = "APICache allows any API client library to be easily wrapped with a robust caching layer. It supports caching (obviously), serving stale data and limits on the number of API calls. It's also got a handy syntax if all you want to do is cache a bothersome url."
    s.authors = ["Martyn Loughran"]
    s.add_development_dependency("rspec")
    s.add_development_dependency("fakeweb")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'api_cache'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
end

task :default => :spec
