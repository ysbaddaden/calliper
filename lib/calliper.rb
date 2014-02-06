require 'selenium/webdriver'
require 'calliper/config'
require 'calliper/page'
require 'calliper/server'
require 'calliper/webdriver'
require 'calliper/rails' if defined?(Rails)
require 'calliper/minitest' if defined?(Minitest)

module Calliper
  def self.server?
    false
  end

  def self.enable!
    server.start
  end
end
