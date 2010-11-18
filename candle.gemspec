# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{candle}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dougal MacPherson"]
  s.date = %q{2010-11-18}
  s.description = %q{A simple gem to retrieve metadata on files via Spotlight on OS X. In development}
  s.email = %q{hello@newfangled.com.au}
  s.extensions = ["ext/spotlight/extconf.rb"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.textile"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.textile",
    "Rakefile",
    "TODO.textile",
    "VERSION",
    "candle.gemspec",
    "ext/spotlight/extconf.rb",
    "ext/spotlight/spotlight.c",
    "lib/candle.rb",
    "lib/candle/base.rb",
    "spec/candle_spec.rb",
    "spec/fixtures/.hidden/example.psd",
    "spec/fixtures/empty-file",
    "spec/fixtures/example.ai",
    "spec/fixtures/example.eps",
    "spec/fixtures/example.gif",
    "spec/fixtures/example.jpg",
    "spec/fixtures/example.pdf",
    "spec/fixtures/example.png",
    "spec/fixtures/example.ps",
    "spec/fixtures/example.svg",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/dougalmacpherson/candle}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Using OS X spotlight to retrieve file metadata}
  s.test_files = [
    "spec/candle_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.1.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
    else
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    end
  else
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
  end
end

