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

  get "index" do
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
    new_user = username

    if params[:password] != params[:password_confirmation] || username == ""
      flash[:notice] = "Error: Try again!"
      redirect :registration
    elsif new_user != nil
      password = params[:password]
      @user_database.insert({username: username, password: password})
      flash[:notice] = "HI!" + username
      new_user = nil
      redirect "/"
    end
  end


end
