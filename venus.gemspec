# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'venus/version'

Gem::Specification.new do |gem|
  gem.name          = "venus"
  gem.version       = Venus::VERSION
  gem.authors       = ["marsz"]
  gem.email         = "marsz@5fpro.com"
  gem.description   = %q{ Use rails generator to install and setup rubygems such as rspec, devise, omniauth-facebook...etc. Also can use in exists projects. }
  gem.summary       = %q{ Use rails generator to install and setup rubygems such as rspec, devise, omniauth-facebook...etc. Also can use in exists projects. }
  gem.homepage      = "https://github.com/marsz/venus"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'railties', '>=3.2.17'
  gem.add_dependency 'activesupport', '>=3.2.17'
  gem.add_dependency 'bundler', '>= 1.1'
end
