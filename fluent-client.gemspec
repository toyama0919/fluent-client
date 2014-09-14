# -*- encoding: utf-8 -*-

require File.expand_path('../lib/fluent/client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "fluent-client"
  gem.version       = Fluent::Client::VERSION
  gem.summary       = %q{fluentd command line utility}
  gem.description   = %q{fluentd command line utility}
  gem.license       = "MIT"
  gem.authors       = ["Hiroshi Toyama"]
  gem.email         = "toyama0919@gmail.com"
  gem.homepage      = "https://github.com/toyama0919/fluent-client"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'thor', '~> 0.19.1'
  gem.add_dependency 'fluentd'
  gem.add_dependency 'yajl-ruby'
  gem.add_dependency 'fluent-logger'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'bundler', '~> 1.7.2'
  gem.add_development_dependency 'rake', '~> 10.3.2'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
