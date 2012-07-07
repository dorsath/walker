require 'model'

describe Model do
  subject { Model.new("model.dae") }

  it "should be able to find all geometries" do
    g = subject.all_geometries
    g.keys.should include("ID2","ID10","ID18","ID26","ID32","ID40")
  end

  it "should be able to find the vertices for the geometries" do
    g = subject.all_geometries
    g["ID2"][:vertices].count.should == 72
  end

  it "should be able to find the indices for the geometries" do
    g = subject.all_geometries
    g["ID18"][:indices].count.should == 210
  end

  it "should be able to find the library effects" do
    g = subject.all_library_effects
    g.keys.should include("ID4", "ID12", "ID20", "ID33", "ID42")
  end

  it "should be able to find all materials" do
    g = subject.all_materials
    g.keys.should include("ID3", "ID11", "ID19", "ID34", "ID41")
  end

  it "should be able to find a material and its effect" do
    g = subject.all_materials["ID3"]
    g[:color].should include(0.1764706, 0.2549020, 1.0000000, 1.0000000)
  end

  it "should be able to find the geometries in the scene" do
    g = subject.scene_geometries
    # p g
  end
end
