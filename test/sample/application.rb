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
    content_type 'application/json'
    sleep rand(0.1..0.5)
    (1..20).map { |id| { id: id, message: "this is notification ##{id}" } }.reverse.to_json
  end
end
