require 'xmlsimple'
config = XmlSimple.xml_in('models/cross.dae')

data = []
config["library_geometries"].first["geometry"].each do |t| #first["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
  vertices = t["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
  indices  = t["mesh"].first["triangles"].first["p"].first.split(" ").collect { |t| t.to_f }
  data << {vertices: vertices, indices: indices}
end

p data
