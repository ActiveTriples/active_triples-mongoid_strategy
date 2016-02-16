# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_triples/mongoid_strategy/version"

Gem::Specification.new do |s|
  s.name        = "active_triples-mongoid_strategy"
  s.version     = ActiveTriples::MongoidStrategy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["MJ Suhonos"]
  s.homepage    = 'https://github.com/ActiveTriples/active_triples-mongoid_strategy'
  s.email       = 'mj@suhonos.ca'
  s.summary     = %q{Mongoid persistence for ActiveTriples.}
  s.description = %q{active_triples-mongoid_strategy provides a graph-based MongoDB persistence strategy for ActiveTriples.}
  s.license     = "Apache-2.0"
  s.required_ruby_version     = '>= 2.0.0'

  s.add_dependency('active-triples', '~> 0.8')
  s.add_dependency('mongoid', '~> 5.0')

  s.add_development_dependency('pry')
  s.add_development_dependency('pry-byebug')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rdf-spec')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('guard-rspec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
end