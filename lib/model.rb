require 'xmlsimple'
class Model

  attr_reader :data

  def initialize(filename)
    @raw_data = XmlSimple.xml_in("models/#{filename}")
    @data = {:scene => scene_geometries, :textures => library_images}
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

        vertices = []
        normals = []
        texcoords = []
        indices = indices_info["p"].first.split(" ").collect { |t| t.to_i }
        indices_vertice_source_id = indices_info["input"].each do |d|
          indices_vertice_source_id = d['source'].delete("#")
          if d["semantic"] == "VERTEX"
            vertice_info = g["mesh"].first["vertices"].find{ |a| a["id"] == indices_vertice_source_id}["input"]
            indices_vertice_id = vertice_info.find{ |t| t["semantic"] == "POSITION" }["source"].delete("#")
            indices_normals_id = vertice_info.find{ |t| t["semantic"] == "NORMAL" }["source"].delete("#")

            vertices += g["mesh"].first["source"].find{ |a| a["id"] == indices_vertice_id }["float_array"].first["content"].split(" ").collect{ |t| t.to_f}
             normals += g["mesh"].first["source"].find{ |a| a["id"] == indices_normals_id }["float_array"].first["content"].split(" ").collect{ |t| t.to_f}
          else
            texcoords = g["mesh"].first["source"].find{ |a| a["id"] == indices_vertice_source_id}["float_array"].first["content"].split(" ").collect{ |t| t.to_f}
          end
        end

        unless texcoords.empty?
          new_indices = [] #apparantly sketchup saves the indices double.
          indices.each_with_index do |v,i|
            new_indices << v if i.odd?
          end
          indices = new_indices
        end
        # indices_count = (indices_info["count"].to_i * 3)
        # indices =  indices[(0..indices_count)]

        @geometries[geometry_id] = {:vertices => vertices,:normals => normals, :indices => indices, :texcoords => texcoords}
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

        color_info = f["profile_COMMON"].first["technique"].first["lambert"].first.first
        color_type = color_info[0]
        if color_info[1].first.first[0] == "texture"

          texture_id = color_info[1].first["texture"].first["texture"]
          source_id = f["profile_COMMON"].first["newparam"].find{|a| a["sid"] == texture_id }["sampler2D"].first["source"].first
          actual_texture_id = f["profile_COMMON"].first["newparam"].find{|a| a["sid"] == source_id }["surface"].first["init_from"].first

          texture = library_images.index(library_images.find{ |i| i[:id] == actual_texture_id})
        else
          #todo normale kleuren color_info[1].first.first[1].first.split(" ").collect{ |i| i.to_f}

        end

        @effects[effect_id] = {:type => color_type, :texture => texture}
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

  def library_images
    if @images
      @images
    else
      @images = []
      @raw_data["library_images"].first["image"].each do |image|
        @images << {:id => image["id"], :src => image["init_from"].first}
      end
      @images
    end
  end

end
