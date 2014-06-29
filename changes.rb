require 'bundler'
Bundler.require

configure do
  require_relative 'site'
  DataMapper.finalize

  enable :sessions
end

configure :production do
  DataMapper::Logger.new($stdout, :info)
end

configure :test do
  ENV['DATABASE_URL'] = 'postgres://localhost/changes_test'
  DataMapper::Logger.new($stdout, :error)
end

configure :development do
  ENV['DATABASE_URL'] = 'postgres://localhost/changes'
  DataMapper::Logger.new($stdout, :debug)
end

configure do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

get '/' do
  haml :index
end

post '/sites' do
  @site = Site.new(params['site'])
  if @site.save
    flash[:message] = "Site added"
  else
    flash[:error] = @site.errors.to_a.flatten.join('. ')
  end
  redirect '/'
end
