# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iphone_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "iphone_parser"
  spec.version       = IphoneParser::VERSION
  spec.authors       = ["fotanus@gmail.com"]
  spec.email         = ["Felipe Tanus"]
  spec.summary       = %q{Parser for iphone resource files}
  spec.description   = %q{Parse iphone resource files to extract strings, and create a file with the given strings}
  spec.homepage      = "http://fotanus.com"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "treetop", "~> 1.5"
end
