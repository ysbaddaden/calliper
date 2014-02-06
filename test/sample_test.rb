require 'test_helper'

class NotificationsPage < Calliper::Page
  def get
    super "/"
  end

  def toggle
    find_element(:css, '.toggle-notifications').click
  end

  def list
    find_element(:css, '.notification-list')
  end

  def notifications
    list.find_elements(:repeater, 'notification in notifications')
  end
end

class NotificationsTest < Minitest::Test
  def setup
    @page = NotificationsPage.get
  end

  def test_toggle_button
    refute @page.list.is_visible?, "it should be hidden by default"

    @page.toggle
    assert @page.list.is_visible?, "it should be visible now"

    @page.toggle
    refute @page.list.is_visible?, "it should be hidden now"
  end

  def test_toggle_button
    @page.toggle
    assert_equal 20, @page.notifications.count

    assert_equal "20",
      @page.notifications.first.find_element(:css, '.notification-id').text
    assert_equal "1",
      @page.notifications.last.find_element(:css, '.notification-id').text

    assert_equal "this is notification #1",
      @page.notifications.last.find_element(:css, '.notification-message').text
  end
end
