module Calliper
  # Scripts are from Protractor:
  #   https://github.com/angular/protractor/blob/master/lib/clientsidescripts.js
  CLIENT_SIDE_SCRIPTS = {
    # Wait until Angular has finished rendering and has
    # no outstanding $http calls before continuing.
    wait_for_angular: <<-JAVASCRIPT
      var el = document.querySelector('[ng-app]');
      var callback = arguments[0];
      try {
        angular.element(el).injector().get('$browser').
          notifyWhenNoOutstandingRequests(callback);
      } catch (e) {
        callback(e);
      }
      JAVASCRIPT
  }

  def self.wait_for_angular
    driver.execute_async_script(CLIENT_SIDE_SCRIPTS[:wait_for_angular])
  end
end
