# -*- encoding: utf-8 -*-
require File.expand_path('../lib/calliper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Portalier"]
  gem.email         = ["julien@portalier.com"]
  gem.description   = gem.summary = "Protractor for Ruby, or testing your Angular application with elegance."
  gem.homepage      = "http://github.com/ysbaddaden/calliper"
  gem.license       = "MIT"

  gem.files         = `git ls-files | grep -Ev '^(Gemfile|test)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "calliper"
  gem.require_paths = ["lib"]
  gem.version       = Calliper::VERSION::STRING

  gem.cert_chain    = ['certs/ysbaddaden.pem']
  gem.signing_key   = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/

  gem.add_dependency 'selenium-webdriver'
  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'minitest'
end
