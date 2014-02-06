require 'bundler'
Bundler.require(:default, :test)

require_relative 'sample/application'

Calliper.setup do |config|
  config.application = SampleApplication
  config.port = 3002
  config.browser_name = ENV['BROWSER'].to_sym if ENV['BROWSER']
end

Calliper.enable!
