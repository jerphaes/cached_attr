# encoding: utf-8

#$: << File.expand_path('../lib', __FILE__)
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cached_attr'

Gem::Specification.new do |s|
  s.name          = 'caches_attr'
  s.version       = '0.1'
  s.authors       = ['Jerphaes van Blijenburgh']
  s.email         = ['jerphaes@gmail.com']
  s.homepage      = 'http://github.com/jerphaes/cache_attr'
  s.summary       = %q{Cacheable Ruby attributes}
  s.description   = %q{Cacheable Ruby attributes}
  s.license       = 'Apache License 2.0'

  s.files         = Dir['lib/*.rb', 'lib/**/*.rb', 'README.md']
  s.test_files    = Dir['spec/*.rb']
  s.require_paths = %w(lib)

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov', '0.7.1'

end