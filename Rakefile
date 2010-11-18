
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e

  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code

end

require 'rake'
require 'rake/extensiontask'
require 'jeweler'
  

Jeweler::Tasks.new do |gem|

  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  gem.name = "candle"
  gem.homepage = "http://github.com/dougalmacpherson/candle"
  gem.summary = %Q{Using OS X spotlight to retrieve file metadata}
  gem.description = %Q{A simple gem to retrieve metadata on files via Spotlight on OS X. In development}
  gem.license = "MIT"

  gem.email = "hello@newfangled.com.au"
  gem.authors = ["Dougal MacPherson"]

  # Development dependencies managed via bundler
  # see Gemfile for more information 
  
end

Jeweler::GemcutterTasks.new


Rake::ExtensionTask.new('spotlight') do |ext|
  ext.lib_dir = 'lib/candle'
end



# Testing via rspec
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

# RSpec::Core::RakeTask.new(:rcov) do |spec|
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end

task :default => :spec

# require 'rake/rdoctask'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
# 
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "candle #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end