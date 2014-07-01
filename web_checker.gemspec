# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'web_checker/version'

Gem::Specification.new do |spec|
  spec.name          = 'web_checker'
  spec.version       = WebChecker::VERSION
  spec.authors       = ['Vitaliy V. Shopov']
  spec.email         = ['vitaliy.shopov@cleawing.com']
  spec.summary       = %q{A simple service for checking a availability of web resource}
  spec.description   = %q{A simple service for checking a availability of web resource}
  spec.homepage      = 'https://github.com/unitymind/web_checker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'whois'
  spec.add_dependency 'twilio-ruby'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'mail'
  spec.add_dependency 'notify'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'rspec'
end
