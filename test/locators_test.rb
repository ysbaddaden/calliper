require 'test_helper'
require_relative 'sample_page'

class LocatorsTest < Minitest::Test
  def setup
    @page = SamplePage.get
    @page.toggle_notifications
  end

  def teardown
    SampleApplication.reset!
  end

  def test_toggle
    assert @page.list_visible?
    @page.toggle_notifications
    refute @page.list_visible?
  end

  def test_repeater_locator
    assert_equal 20, @page.notifications.count
    assert_equal 2, @page.messages.count
  end

  def test_chaining
    notification = @page.notifications.last
    assert_equal '1', notification.find_element(:css, '.notification-id').text
    assert_equal 'this is notification #1',
      notification.find_element(:css, '.notification-message').text
  end

  def test_binding_locator
    assert_equal (1..20).map(&:to_s).reverse,
      @page.list.find_elements(:binding, 'notification.id').map(&:text)

    assert_equal (1..2).map(&:to_s).reverse,
      @page.find_elements(:binding, 'message.id').map(&:text)

    assert_equal 'first message',
      @page.messages.last.find_element(:binding, 'message.body').text
  end

  def test_model_locator
    assert_difference -> { @page.messages.count } do
      @page.message_form.find_element(model: 'message.body').send_keys('hey dude')
      @page.message_form.find_element(css: 'input[type=submit]').click
    end

    assert_equal 'hey dude', @page.messages.first.find_element(:binding, 'message.body').text
    assert_empty @page.find_element(:model, 'message.body').attribute('value')
  end

  def test_find_element_raises_no_such_element_error
    exception = assert_raises(Selenium::WebDriver::Error::NoSuchElementError) do
      @page.find_element(model: "my.model.name")
    end
    assert_equal "cannot locate element with model: my.model.name", exception.message

    exception = assert_raises(Selenium::WebDriver::Error::NoSuchElementError) do
      @page.find_element(repeater: "record in unknown_records")
    end
    assert_equal "cannot locate element with repeater: record in unknown_records", exception.message
  end
end
