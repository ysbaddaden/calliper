require 'test_helper'
require_relative 'sample_page'

class ModuleInjectionTest < Minitest::Test
  def setup
    @page = SamplePage.new
    @page.add_mock_module 'mockFailure', <<-JAVASCRIPT
      angular.module('mockFailure', ['ngMockE2E'])
        .run(function ($httpBackend) {
          $httpBackend.whenPOST('/messages.json').respond(500);
        });
      JAVASCRIPT
    @page.get
  end

  def teardown
    SampleApplication.reset!
    @page.clear_mock_modules
  end

  def test_mocked_failure
    refute_difference -> { @page.messages.count } do
      @page.message_form.find_element(model: 'message.body').send_keys('hey dude')
      @page.message_form.find_element(css: 'input[type=submit]').click
    end
  end
end
