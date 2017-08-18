# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capwatch/version"

Gem::Specification.new do |spec|
  spec.name          = "capwatch"
  spec.version       = Capwatch::VERSION
  spec.authors       = ["Nick Bugaiov"]
  spec.email         = ["nick@bugaiov.com"]

  spec.summary       = "Cryptoportfolio watch"
  spec.description   = "Watches your cryptoportfolio"
  spec.homepage      = "https://cryptowatch.one"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "terminal-table", "~> 1.8"
  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "telegram_bot", "~> 0.0.7"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakefs", "~> 0.11"
end
