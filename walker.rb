require 'sinatra'

get '/' do
  erb :index
end

get '/fastest' do
  erb :fastest
end

get '/animation' do
  erb :animation
end
