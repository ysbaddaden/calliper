require 'bundler'
Bundler.require(:default, :test)

require_relative 'sample/application'

Calliper.setup do |config|
  config.application = SampleApplication

  if ENV['CI']
    config.driver = :remote
    config.remote_url = "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub"
    config.capabilities = {
      'name' => 'Calliper',
      'build' => ENV['TRAVIS_BUILD_NUMBER'],
      'tunnel-identifier' => ENV['TRAVIS_JOB_NUMBER'],
      'browserName' => ENV['BROWSER'] || 'firefox',
    }
  else
    config.driver = (ENV['BROWSER'] || :firefox).to_sym
  end
end

Calliper.enable!

class Minitest::Test
  def assert_difference(counter, difference = 1, message = nil)
    count = counter.call
    yield
    assert_equal count + difference, counter.call,
      message || "Expected #{counter} to change by #{difference}"
  end

  def refute_difference(counter, message = nil, &block)
    assert_difference(counter, 0, message, &block)
  end
end
