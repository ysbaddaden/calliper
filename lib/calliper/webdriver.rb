require 'socket'

module Calliper
  # FIXME: Only firefox quits correctly when used directly. There are no
  #   problems when using a Selenium Server.
  def self.driver
    @driver ||= if local_server_running?
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

  def self.local_server_running?
    begin
      TCPSocket.new('localhost', 4444).close
      true
    rescue
      false
    end
  end

  def self.driver?
    !!@driver
  end
end

# We're hacking our way into WebDriver locators in order to emulate some
# nice Protractor locators.
#
# FIXME: use real locators that use protractor's client-side finders:
#   https://github.com/angular/protractor/blob/master/lib/clientsidescripts.js
module Selenium::WebDriver::SearchContext
  %w(find_element find_elements).each do |name|
    alias_method "#{name}_without_angular", name

    define_method name do |*args|
      __send__("#{name}_without_angular", *angular_custom_locator(args))
    end
  end

  private

    def angular_custom_locator(args)
      case args.size
      when 2
        how, what = args
      when 1
        how = args.first.keys.first
        what = args.first[how]
      else
        return args
      end

      case how
      when :model
        [:css, angular_prefixes.map { |prefix| "[#{prefix}model='#{what}']"  }.join(", ")]
      when :repeater
        [:css, angular_prefixes.map { |prefix| "[#{prefix}repeat^='#{what}']"  }.join(", ")]
      else
        args
      end
    end

    def angular_prefixes
      @angular_prefixes ||= %w(ng- ng_ data-ng- x-ng- ng\\:)
    end
end
