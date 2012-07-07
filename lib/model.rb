require 'xmlsimple'
class Model

  attr_reader :data

  def initialize(filename)
    @raw_data = XmlSimple.xml_in("models/#{filename}")
    @data = scene_geometries
  end

  def scene_geometries
    scene_geometries = []
    scene = @raw_data["library_visual_scenes"].first["visual_scene"].first
    scene["node"].first["instance_geometry"].each do |g|
      geometry_id = g["url"].delete("#")
      geometry    = all_geometries[geometry_id]
      material_id = g["bind_material"].first["technique_common"].first["instance_material"].first["target"].delete("#")
      material    = all_materials[material_id]

      scene_geometries << {:geometry => geometry, :material => material}
    end
    scene_geometries
  end

  def all_geometries
    if @geometries
      @geometries
    else
      @geometries = {}
      @raw_data["library_geometries"].first["geometry"].each do |g|
        geometry_id = g["id"]

        indices_info = g["mesh"].first["triangles"].first

        indices = indices_info["p"].first.split(" ").collect { |t| t.to_f }
        indices_vertice_source_id = indices_info["input"].first['source'].delete("#")

        indices_vertice_id = g["mesh"].first["vertices"].find{ |a| a["id"] == indices_vertice_source_id}["input"].find{ |t| t["semantic"] == "POSITION" }["source"].delete("#")
        vertices = g["mesh"].first["source"].find{ |a| a["id"] == indices_vertice_id }["float_array"].first["content"].split(" ").collect{ |t| t.to_f}

        @geometries[geometry_id] = {:vertices => vertices, :indices => indices}
      end

      @geometries
    end
  end

  def all_library_effects
    if @effects
      @effects
    else
      @effects = {}
      @raw_data["library_effects"].first["effect"].each do |f|
        effect_id = f["id"]

        color_info = f["profile_COMMON"].first.first[1].first["lambert"].first.first
        color_type = color_info[0]
        colors = color_info[1].first["color"].first.split(" ").collect { |t| t.to_f }

        @effects[effect_id] = {:type => color_type, :color => colors}
      end
      @effects
    end
  end

  def all_materials
    if @materials
      @materials
    else
      @materials = {}

      @raw_data["library_materials"].first["material"].each do |t|
        effect_id = t["instance_effect"].first["url"].delete("#")
        @materials[t["id"]] = all_library_effects[effect_id]
      end

      return @materials
    end
  end

end
