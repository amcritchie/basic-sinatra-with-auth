require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  get "/" do
    erb :index
  end

  get "/registration" do
    erb :registration
  end

  get '/login' do
    erb :registration
  end


  post "/login" do
    username = params[:username]

    if params[:password] != params[:password_confirmation] || username == ""
      redirect :registration
    end
    password = params[:password]
    @user_database.insert({username: username, password: password})

    erb :index
  end



end
