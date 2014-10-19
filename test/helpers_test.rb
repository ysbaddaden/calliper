require 'test_helper'
require_relative 'sample_page'

class HelpersTest < Minitest::Test
  def setup
    @page = SamplePage.get
    @page.toggle_notifications
  end

  def test_current_uri
    assert_instance_of URI::HTTP, @page.current_uri
    assert_equal 'http', @page.current_uri.scheme
    assert_equal '127.0.0.1', @page.current_uri.host
    assert_equal '/', @page.current_uri.path
  end

  def test_present?
    element = @page.find_element(css: '.notification-list')
    assert @page.present?(css: '.notification-list')
    assert @page.present?(element)

    @page.toggle_notifications

    refute @page.present?(css: '.notification-list')
    refute @page.present?(element)
  end
end
