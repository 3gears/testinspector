# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viewcumber/version'

Gem::Specification.new do |spec|
  spec.name          = "viewcumber"
  spec.version       = Viewcumber::VERSION
  spec.authors       = ["Jonas Schneider", "gregbell", "pcreux", "samuelreh"]
  spec.email         = ["mail@jonasschneider.com"]
  spec.summary       = %q{Cucumber formatter for viewing the current page at each step}
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency(%q<capybara>, [">= 0.3"])
  spec.add_runtime_dependency(%q<cucumber>, [">= 1.1.4"])
  spec.add_runtime_dependency(%q<jeweler>, [">= 0"])
end
