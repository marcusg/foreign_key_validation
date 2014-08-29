# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreign_key_validation/version'

Gem::Specification.new do |spec|
  spec.name          = "foreign_key_validation"
  spec.version       = ForeignKeyValidation::VERSION
  spec.authors       = ["Marcus Geißler"]
  spec.email         = ["marcus3006@gmail.com"]
  spec.summary       = %q{Protect the foreign keys in your Rails models.}
  spec.description   = %q{Protect the foreign keys in your Rails models. Really.}
  spec.homepage      = "https://github.com/marcusg/foreign_key_validation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
