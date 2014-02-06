module Calliper
  module Config
    extend self

    attr_accessor :application
    attr_accessor :base_host
    attr_accessor :base_url
    attr_accessor :browser_name
    attr_accessor :capabilities
    attr_accessor :driver
    attr_accessor :port
    attr_accessor :remote_url

    def base_url
      @base_url ||= if base_host
                      build_base_url_from_host
                    else
                      Calliper.server.url
                    end
    end

    def browser_name
      @browser_name ||= :firefox
    end

    private

      def build_base_url_from_host
        url = "http://#{base_host}"

        if Calliper.server?
          url + ":#{Calliper.server.port}"
        elsif port
          url + ":#{port}"
        else
          url
        end
      end
  end

  def self.setup
    yield Config
  end
end
