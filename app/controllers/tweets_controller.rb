class TweetsController < ApplicationController
enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

  get '/tweets' do
    if !!session[:user_id]
      @user = User.find_by(id: session[:user_id])
      @tweets = Tweet.all
      erb :"/tweets/index"
    else 
      redirect to '/login'
    end 
  end

  get '/tweets/new' do
    if !!session[:user_id]
      erb :"/tweets/new"
    else 
      redirect to "/login"
    end 
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to "/tweets/new"
    else
      User.find_by(id: session[:user_id]).tweets.create(content: params[:content])
    end 
  end

  get '/tweets/:id' do
    if !!session[:user_id]
      
      @tweet = Tweet.find_by(id: params[:id])
      erb :"/tweets/show"
    else 
      redirect to "/login"
    end 
  end

  get '/tweets/:id/edit' do
    if !!session[:user_id] && @tweet = User.find_by(id: session[:user_id]).tweets.find_by(id: params[:id])
      erb :"/tweets/edit"
    else 
      redirect to "/login"
    end
  end

  patch '/tweets/:id' do
    tweet = Tweet.find_by(id: params[:id])
    if params[:content].empty? || tweet.user.id != session[:user_id]
      redirect to "/tweets/#{tweet.id}/edit"
    else 
      tweet.update(content: params[:content])
      tweet.save
      redirect to "/tweets/#{tweet.id}"
    end 
  end

  delete '/tweets/:id' do
    tweet = Tweet.find_by(id: params[:id])
    if !!session[:user_id] && tweet.user.id == session[:user_id]
      tweet.delete 
      redirect to "/tweets"
    else
      redirect to '/login'
    end 
  end 

end
