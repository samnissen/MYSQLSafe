# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'MYSQLSafe/version'

Gem::Specification.new do |spec|
  spec.name          = "MYSQLSafe"
  spec.version       = MYSQLSafe::VERSION
  spec.authors       = ["Sam NIssen"]
  spec.email         = ["Samuel.Nissen@LinkShare.com"]
  spec.description   = %q{Connect to MYSQL more easily}
  spec.summary       = %q{An abstraction of the MYSQL gem to automatically close connections, return arrays and sanatize some of the inputs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "mysql"
end
