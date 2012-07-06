class Model
  def self.load(filename)
    config = XmlSimple.xml_in("models/#{filename}")

    library_effects = {}
    config["library_effects"].first["effect"].each do |e|
      library_effects[e["id"]] = e["profile_COMMON"].first["technique"].first["lambert"].first["diffuse"].first["color"].first.split(" ").collect {|t| t.to_f}
    end

    materials = {}
    config["library_materials"].first["material"].each do |m|
      color = library_effects[m["instance_effect"].first["url"].delete("#")]
      materials[m["id"]] = {color: color}
    end

    obj_material = {}
    config["library_visual_scenes"].first["visual_scene"].first["node"].first["instance_geometry"].each do |m|
      t = m["bind_material"].first["technique_common"].first["instance_material"].first["target"].delete("#")
      obj_material[m["url"].delete("#")] = {effects: materials[t]}
    end

    data = []
    config["library_geometries"].first["geometry"].each do |t| #first["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
      vertices = t["mesh"].first["source"].first["float_array"].first["content"].split(" ").collect { |t| t.to_f }
      indices  = t["mesh"].first["triangles"].first["p"].first.split(" ").collect { |t| t.to_f }
      material = obj_material[t["id"]]
      data << {vertices: vertices, indices: indices, material: material}
    end

    data
  end
end
