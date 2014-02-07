require 'selenium/webdriver'
require 'calliper/config'
require 'calliper/page'
require 'calliper/server'
require 'calliper/webdriver'
require 'calliper/minitest' if defined?(Minitest)

module Calliper
  def self.enable!
    application = Config.application || (::Rails.application if defined?(::Rails))
    raise "No application configured" unless application

    logger = ::Rails.logger if defined?(::Rails)

    @server = Server.new(application, logger: logger)
    @server.start
  end

  def self.server
    @server
  end

  def self.server?
    !!@server
  end
end
