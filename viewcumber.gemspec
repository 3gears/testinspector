# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "viewcumber"
  spec.version       = "0.4"
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

  spec.add_runtime_dependency "rails", "~> 4"
  spec.add_runtime_dependency "cucumber", "~> 1.3"
  spec.add_runtime_dependency "capybara", "~> 2.4"
end
