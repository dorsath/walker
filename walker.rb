require 'sinatra'
require 'xmlsimple'
require 'json'

require './lib/model'


get '/' do
  @data = Model.load('model.dae')

  erb :index
end

get '/model' do

  content_type :json
  {vertices: vertices, indices: indices}.to_json
end

get '/fastest' do
  erb :fastest
end

get '/animation' do
  erb :animation
end
