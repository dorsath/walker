require 'sinatra'
require 'xmlsimple'
require 'json'


get '/' do
  config = XmlSimple.xml_in('models/cross.dae')

  @data = []
  config["library_geometries"].first["geometry"].each do |t| #first["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
    vertices = t["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
    indices  = t["mesh"].first["triangles"].first["p"].first.split(" ").collect { |t| t.to_f }
    @data << {vertices: vertices, indices: indices}
  end
  p @data

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
