# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "graphql/model/version"

Gem::Specification.new do |spec|
  spec.name          = "graphql-model"
  spec.version       = GraphQL::Model::VERSION
  spec.authors       = ["Ben Aubin"]
  spec.email         = ["ben@bensites.com"]

  spec.summary       = %q{A DSL for using GraphQL.}
  spec.description   = %q{A Ruby library to make using GraphQL 100% more awesome}
  spec.homepage      = "https://github.com/benaubin/graphql-model"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'activesupport', ">= 4"
  spec.add_dependency 'activemodel', ">= 4"
  spec.add_dependency 'http', "~> 2.2"
end
