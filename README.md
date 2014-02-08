# Calliper

Protractor for Ruby, or testing your Angular application with elegance.

Thought this is only but a (working) hack for now.

## Support

It currently supports Rack and Rails applications with Minitest, but it should
be possible to hack in support for other frameworks (eg: Sinatra, RSpec).

## Usage

Add the calliper gem to your Gemfile:

```ruby
gem 'calliper'
```

Enable it in your `test_helper`:

```ruby
Calliper.enable!
```

Then write a page abstraction and your tests:

```ruby
# test/integration/user_notifications_test.rb

class UserNotificationsPage < Calliper::Page
  def get(user)
    super "/users/#{users.to_param}/notifications"
  end

  def notifications
    find_element(repeater: 'notification in user.notifications')
  end

  def form
    find_element(css: 'form.notification')
  end
end

class UserNotificationsIntegrationTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
    @page = UserNotificationsPage.get(@user)
  end

  test "notifications list" do
    assert_equal @user.notifications.count, @page.notifications.count
  end

  test "leave a message" do
    assert_difference('@page.notifications.count') do
      @page.form.find_element(model: 'notification.message').send_keys("hey dude\n")
    end
    assert_equal "hey dude", @page.notifications.last.find_element(class: 'message').text
  end
end
```

Please note that a page abstraction isn't required, but you must always send
your WebDriver methods throught an instance of `Calliper::Page` because these call
will wait for angular to be ready. Calling directly methods on `Calliper.driver`
won't wait and may be unsynced and fail randomly.

### Run tests

Calliper will detect if a Selenium WebDriver server has been started locally on
`http://localhost:4444/wd/hub` and use it. Otherwise it will launch the driver
directly (it defaults to firefox). Alternatively you may configure it to run
your tests on Sauce Labs for example:

```ruby
Calliper.setup do |config|
  config.driver = :remote
  config.remote_url = "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com/wd/hub"
  config.capabilities = {
    name: 'my_app_name',
    browserName: ENV['BROWSER'] || 'firefox',
  }
end
```

## Credits

- Rack Server class is from [Teaspoon](https://github.com/modeset/teaspoon)
- Overall design and client side scripts are from
  [Protractor](https://github.com/angular/protractor)

