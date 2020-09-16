require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if !!session[:user_id]
      redirect to "/tweets"
    else 
      erb :signup
    end 
  end

  post '/signup' do 
    if params.values.all? { |value| !value.empty? }
      @user = User.create(params)
      session[:user_id] = @user.id

      redirect to "/tweets"
    else
      redirect to "/signup"
    end
  end

  get '/login' do
    if !!session[:user_id]
      redirect to "/tweets"
    else 
      erb :login
    end 
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])      
      session[:user_id] = user.id

      redirect to "/tweets"
    else 
      redirect to "/failure"
    end
  end

  get '/logout' do
    if session[:user_id]
      session.clear
      redirect to '/login'
    else 
      redirect to '/'
    end
  end

  get '/failure' do
    erb :failure
  end

end
