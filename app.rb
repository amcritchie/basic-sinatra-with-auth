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

  get "/user_home" do
    erb :user_home
  end

  post '/login' do
    if (params[:username] || params[:password]) == ""
      flash[:notice] = "Please enter user information."
      redirect "/"
    end
    p id = @user_database.find_user(params[:username],params[:password])
    if id == nil
      flash[:notice] = "Error: username or password is incorrect!"
      redirect "/"
    end
    p @user_database.all
    # p @user_database.delete(1)
    redirect :user_home
  end

  get "/registration" do
    erb :registration
  end

  post "/registration" do
    new_user = params[:username]
    if params[:password] != params[:password_confirmation] || params[:username] == "" || params[:password] == ""
      flash[:notice] = "Error: try again!"
      redirect :registration
    elsif new_user != nil
      password = params[:password]
      @user_database.insert({username: new_user, password: password})
      flash[:notice] = "HI!" + new_user
      new_user = nil
      redirect "/"
    end
  end


end
