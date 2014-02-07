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
