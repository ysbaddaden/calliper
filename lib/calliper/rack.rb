require 'calliper/server'

module Calliper
  def self.application
    @app
  end

  def self.application=(app)
    @app = app
  end

  def self.server
    @server ||= Server.new(application)
  end

  def self.server?
    !!@server
  end
end
