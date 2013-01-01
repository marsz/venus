# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'venus/version'

Gem::Specification.new do |gem|
  gem.name          = "venus"
  gem.version       = Venus::VERSION
  gem.authors       = ["marsz"]
  gem.email         = ["marsz@5fpro.com"]
  gem.description   = %q{  }
  gem.summary       = %q{  }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'railties'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'bundler', '>= 1.1'
end
