require 'bundler'
Bundler.require

require_relative 'user'

configure do
  enable :sessions

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

helpers do
  # define a current_user method, so we can be sure if an user is authenticated
  def logged_in?
    !session[:uid].nil?
  end
end

before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  pass if request.path_info =~ /^\/auth\//

  # /auth/twitter is captured by omniauth:
  # when the path info matches /auth/twitter, omniauth will redirect to twitter
  redirect to('/auth/twitter') unless logged_in?
end

get '/auth/twitter/callback' do
  session[:uid] = env['omniauth.auth']['uid']
  User.new(env['omniauth.auth']).save
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
end

get '/' do
  "Hello #{$redis.hgetall("users:#{session[:uid]}")}"
end

get '/logout' do
  session[:uid] = nil
  redirect to('/')
end
