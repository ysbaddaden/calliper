module Calliper
  class Page
    attr_writer :base_url

    def self.get(*args)
      page = new
      page.get(*args)
      page
    end

    def get(path, options = {})
      url = path =~ %r(^http://) ? path : "#{base_url}#{path}"
      driver.get(url)

      if options[:sync].nil? || options[:sync]
        wait = Selenium::WebDriver::Wait.new(timeout: 10)
        wait.until { driver.find_element(css: "[ng-app]") }
      end
    end

    def base_url
      @base_url ||= Config.base_url
    end

    def driver
      Calliper.driver
    end

    def method_missing(method_name, *args)
      if driver.respond_to?(method_name)
        Calliper.wait_for_angular
        driver.__send__(method_name, *args)
      else
        super
      end
    end
  end
end
