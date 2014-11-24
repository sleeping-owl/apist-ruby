# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apist'

Gem::Specification.new do |spec|
  spec.name          = "apist"
  spec.version       = Apist::VERSION
  spec.authors       = ["Sleeping Owl"]
  spec.email         = ["owl.sleeping@yahoo.com"]
  spec.summary       = %q{Package to provide api-like access to foreign sites based on html parsing}
  spec.description   = %q{Package to provide api-like access to foreign sites based on html parsing}
  spec.homepage      = "http://sleeping-owl-apist.gopagoda.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency 'httparty'
end
