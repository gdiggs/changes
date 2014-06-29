require 'bundler'
Bundler.require

configure do
  enable :sessions

  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  haml :index
end
