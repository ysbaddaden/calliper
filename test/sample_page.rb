class SamplePage < Calliper::Page
  def get
    super '/'
  end

  def toggle_notifications
    find_element(:class, 'toggle-notifications').click
  end

  def list
    find_element(:class, 'notification-list')
  end

  def list_visible?
    find_elements(:class, 'notification-list').count > 0
  end

  def notifications
    list.find_elements(:repeater, 'notification in notifications')
  end

  def messages
    find_elements(:repeater, 'message in messages')
  end

  def message_form
    find_element(:css, 'form.message')
  end
end
