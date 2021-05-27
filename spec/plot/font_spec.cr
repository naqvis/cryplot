require "../spec_helper"

describe Cryplot::Font do
  it "test font" do
    specs = Cryplot::Font.new
    specs.repr.should eq("")

    specs.font_name("Arial")
    specs.repr.should eq("font 'Arial,'")

    specs.font_size(14)
    specs.repr.should eq("font 'Arial,14'")
  end
end
