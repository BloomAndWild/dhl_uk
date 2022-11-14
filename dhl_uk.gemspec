# frozen_string_literal: true

require_relative 'lib/dhl_uk/version'

Gem::Specification.new do |spec|
  spec.name          = 'dhl_uk'
  spec.version       = DHLUk::VERSION
  spec.authors       = ['Ged Dackys']
  spec.email         = ['ged@bloomandwild.com']

  spec.summary       = 'A Ruby interface to the DHL Express API.'
  spec.homepage      = 'https://github.com/BloomAndWild/dhl_express'
  spec.license       = 'Proprietary'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '> 1.0', '< 2.0'

  spec.add_dependency 'savon', '>= 2.13.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
