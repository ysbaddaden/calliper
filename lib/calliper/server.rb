require 'calliper/config'

module Calliper
  # NOTE: Borrows code from the fantastic Teaspoon gem:
  #   http://github.com/modeset/teaspoon
  class Server
    attr_reader :application, :port, :logger

    def initialize(application, options = {})
      @application = application
      @port = options[:port] || Config.port || find_available_port
      @logger = options[:logger]
    end

    def start
      @thread = Thread.new do
        server = Rack::Server.new(rack_options)
        server.start
      end

      Timeout.timeout(60) do
        @thread.join(0.1) until responsive?
      end
    rescue Timeout::Error
      raise "Server failed to start within 60 seconds."
    rescue => e
      raise "Cannot start server: #{e.message}"
    end

    def responsive?
      return false if @thread && @thread.join(0)
      TCPSocket.new('127.0.0.1', port).close
      return true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    end

    def rack_options
      {
        app: application,
        environment: 'test',
        Port: port,
        AccessLog: [],
        Logger: logger
      }
    end

    def url
      "http://127.0.0.1:#{port}"
    end

    private

      def find_available_port
        server = TCPServer.new('127.0.0.1', 0)
        server.addr[1]
      ensure
        server.close if server
      end
  end
end
