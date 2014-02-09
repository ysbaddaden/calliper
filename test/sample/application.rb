require 'sinatra/base'
require 'json'

class SampleApplication < Sinatra::Base
  configure do
    disable :protection
    disable :sessions
    enable  :static

    set :public_folder, File.expand_path('../public', __FILE__)
    set :view, File.expand_path('../views', __FILE__)
  end

  get '/' do
    erb :index
  end

  get '/notifications.json' do
    sleep rand(0.1..0.5)
    content_type 'application/json'
    self.class.notifications.reverse.to_json
  end

  get '/messages.json' do
    sleep rand(0.1..0.5)
    content_type 'application/json'
    self.class.messages.reverse.to_json
  end

  post '/messages.json' do
    data = JSON.parse(request.body.read)
    message = { id: self.class.messages.size, body: data['body'] }
    self.class.messages << message

    content_type 'application/json'
    message.to_json
  end

  def self.notifications
    @@notifications ||= (1..20).map do |id|
      { id: id, message: "this is notification ##{id}" }
    end
  end

  def self.messages
    @@messages ||= [
      { id: 1, body: "first message" },
      { id: 2, body: "second message" }
    ]
  end

  def self.reset!
    @@messages = @@notifications = nil
  end
end
