module Calliper
  module Helpers
    def current_uri
      URI(driver.current_url)
    end

    def present?(*args)
      if args.size == 1 && args.first.is_a?(Selenium::WebDriver::Element)
        args.first.displayed?
      else
        !!find_element(*args)
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::NoSuchElementError
      false
    end
  end
end
