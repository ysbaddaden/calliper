require 'socket'
require 'calliper/client_side_scripts'

module Calliper
  def self.driver
    @driver ||= begin
      driver = create_webdriver_instance
      driver.manage.timeouts.script_timeout = 11
      driver
    end
  end

  def self.driver?
    !!@driver
  end

  def self.local_server_running?
    begin
      TCPSocket.new('localhost', 4444).close
      true
    rescue
      false
    end
  end

  private

    # FIXME: Only firefox quits correctly when used directly. There are no
    #   problems when using a Selenium Server.
    def self.create_webdriver_instance
      if local_server_running?
        Selenium::WebDriver.for(:remote,
          url: "http://localhost:4444/wd/hub",
          desired_capabilities: { browserName: Config.driver.to_s }
        )
      elsif Config.driver == :remote
        Selenium::WebDriver.for(:remote,
          url: Config.remote_url,
          desired_capabilities: Config.capabilities
        )
      else
        Selenium::WebDriver.for(Config.driver ? Config.driver.to_sym : :firefox)
      end
    end
end

# NOTE: hacking into WebDriver to implement Protractor's locators
module Selenium::WebDriver::SearchContext
  %w(find_element find_elements).each do |name|
    alias_method "#{name}_without_angular", name

    define_method name do |*args|
      Calliper.wait_for_angular
      how, what = angular_parse_search_arguments(args)

      if script = Calliper::ClientSideScripts[:"find_by_#{how}"]
        context = is_a?(Selenium::WebDriver::Element) ? self : nil
        elements = Calliper.driver.execute_script(script, context, what)

        if name == 'find_element'
          return elements.first unless elements.nil? || elements.empty?
          raise Selenium::WebDriver::Error::NoSuchElementError, "cannot locate element with #{how}: #{what}"
        end

        elements
      else
        __send__("#{name}_without_angular", *args)
      end
    end
  end

  private

    def angular_parse_search_arguments(args)
      if args.size == 1
        how = args.first.keys.first
        what = args.first[how]
        [how, what]
      else
        args
      end
    end
end
