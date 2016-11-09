# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamewisp/version'

Gem::Specification.new do |spec|
  spec.name          = "gamewisp"
  spec.version       = Gamewisp::VERSION
  spec.authors       = ["Jeff McAffee"]
  spec.email         = ["jeff@ktechsystems.com"]

  spec.summary       = %q{GameWisp API ruby library}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jmcaffee/gamewisp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "oauth2", "~> 1.2"
  spec.add_dependency "httparty"
  spec.add_dependency "json", "~> 2.0"
end
