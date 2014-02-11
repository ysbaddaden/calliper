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

      # skips angular bootstrap
      return driver.get(url) if options[:sync] == false

      # defers angular bootstrap
      driver.get('about:blank')
      driver.execute_script <<-JAVASCRIPT
        window.name = "NG_DEFER_BOOTSTRAP!" + window.name;
        window.location.assign("#{url}");
        JAVASCRIPT

      # waits for the page to be loaded
      wait = Selenium::WebDriver::Wait.new(timeout: 0.3)
      wait.until { driver.current_url != 'about:blank' }

      # waits for angular to be ready
      success, message = driver.execute_async_script(ClientSideScripts[:test_for_angular], 10)
      raise message unless success

      # injects mocks and resumes bootstrap
      modules.each do |name, script|
        begin
          driver.execute_script(script)
        rescue => e
          raise "An error occured while injecting #{name} script: #{e.message}"
        end
      end
      driver.execute_script("angular.resumeBootstrap(arguments[0]);", modules.keys);
    end

    def modules
      @modules ||= {}
    end

    def add_mock_module(name, script)
      modules[name] = script
    end

    def clear_mock_modules
      @modules = {}
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
