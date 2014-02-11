require 'bundler'
Bundler.require(:default, :test)

require_relative 'sample/application'

Calliper.setup do |config|
  browser = ENV['BROWSER'] || :firefox

  config.application = SampleApplication
  config.base_host = ENV['BASE_HOST']
  config.capabilities = Selenium::WebDriver::Remote::Capabilities.__send__(browser)

  if ENV['CI']
    config.driver = :remote
    config.remote_url = "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub"

    config.capabilities['name'] = 'Calliper'
    config.capabilities['build'] = ENV['TRAVIS_BUILD_NUMBER']
    config.capabilities['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']

    if ENV['BROWSER'] == 'internet_explorer'
      config.capabilities.platform = 'Windows 7'
      config.capabilities.version = '9'
    end
  elsif ENV['REMOTE_URL']
    config.driver = :remote
    config.remote_url = ENV['REMOTE_URL']
  else
    config.driver = browser.to_sym
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
