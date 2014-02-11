module Calliper
  # Scripts are from Protractor:
  #   https://github.com/angular/protractor/blob/master/lib/clientsidescripts.js
  ClientSideScripts = {}

  # Wait until Angular has finished rendering and has no outstanding $http
  # calls before continuing.
  ClientSideScripts[:wait_for_angular] = <<-JAVASCRIPT
    var el = document.querySelector('[ng-app]');
    var callback = arguments[0];
    try {
      angular.element(el).injector().get('$browser')
        .notifyWhenNoOutstandingRequests(callback);
    } catch (e) {
      callback(e);
    }
    JAVASCRIPT

  ClientSideScripts[:test_for_angular] = <<-JAVASCRIPT
    var attempts = arguments[0];
    var callback = arguments[arguments.length - 1];
    var check = function(n) {
      try {
        if (window.angular && window.angular.resumeBootstrap) {
          callback([true, null]);
        } else if (n < 1) {
          if (window.angular) {
            callback([false, 'angular never provided resumeBootstrap']);
          } else {
            callback([false, 'retries looking for angular exceeded']);
          }
        } else {
          window.setTimeout(function() {check(n - 1)}, 1000);
        }
      } catch (e) {
        callback([false, e]);
      }
    };
    check(attempts);
    JAVASCRIPT

  ClientSideScripts[:find_by_binding] = <<-JAVASCRIPT
    var using = arguments[0] || document;
    var binding = arguments[1];
    var bindings = using.getElementsByClassName('ng-binding');
    var matches = [];
    for (var i = 0; i < bindings.length; ++i) {
      var dataBinding = angular.element(bindings[i]).data('$binding');
      if (dataBinding) {
        var bindingName = dataBinding.exp || dataBinding[0].exp || dataBinding;
        if (bindingName.indexOf(binding) != -1) {
          matches.push(bindings[i]);
        }
      }
    }
    return matches; // Return the whole array for webdriver.findElements.
    JAVASCRIPT

  ClientSideScripts[:find_by_model] = <<-JAVASCRIPT
    var using = arguments[0] || document;
    var model = arguments[1];
    var prefixes = ['ng-', 'ng_', 'data-ng-', 'x-ng-', 'ng\\\\:'];
    for (var p = 0; p < prefixes.length; ++p) {
      var selector = '[' + prefixes[p] + 'model="' + model + '"]';
      var elements = using.querySelectorAll(selector);
      if (elements.length) {
        return elements;
      }
    }
    JAVASCRIPT

  ClientSideScripts[:find_by_repeater] = <<-JAVASCRIPT
    var using = arguments[0] || document;
    var repeater = arguments[1];
    var rows = [];
    var prefixes = ['ng-', 'ng_', 'data-ng-', 'x-ng-', 'ng\\\\:'];
    for (var p = 0; p < prefixes.length; ++p) {
      var attr = prefixes[p] + 'repeat';
      var repeatElems = using.querySelectorAll('[' + attr + ']');
      attr = attr.replace(/\\\\/g, '');
      for (var i = 0; i < repeatElems.length; ++i) {
        if (repeatElems[i].getAttribute(attr).indexOf(repeater) != -1) {
          rows.push(repeatElems[i]);
        }
      }
    }
    for (var p = 0; p < prefixes.length; ++p) {
      var attr = prefixes[p] + 'repeat-start';
      var repeatElems = using.querySelectorAll('[' + attr + ']');
      attr = attr.replace(/\\\\/g, '');
      for (var i = 0; i < repeatElems.length; ++i) {
        if (repeatElems[i].getAttribute(attr).indexOf(repeater) != -1) {
          var elem = repeatElems[i];
          var row = [];
          while (elem.nodeType != 8 ||
              elem.nodeValue.indexOf(repeater) == -1) {
            rows.push(elem);
            elem = elem.nextSibling;
          }
        }
      }
    }
    return rows;
    JAVASCRIPT

  ClientSideScripts[:find_by_selected_option] = <<-JAVASCRIPT
    var using = arguments[0] || document;
    var model = arguments[1];
    var prefixes = ['ng-', 'ng_', 'data-ng-', 'x-ng-', 'ng\\\\:'];
    for (var p = 0; p < prefixes.length; ++p) {
      var selector = 'select[' + prefixes[p] + 'model="' + model + '"] option:checked';
      var inputs = using.querySelectorAll(selector);
      if (inputs.length) {
        return inputs;
      }
    }
    JAVASCRIPT

  def self.wait_for_angular
    driver.execute_async_script(ClientSideScripts[:wait_for_angular])
  end
end
