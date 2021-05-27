require "../spec_helper"

describe Cryplot::Text do
  it "test Text" do
    text = Cryplot::Text.new

    text.repr.should eq("enhanced textcolor '#404040'")

    text.text_color("red")

    text.repr.should eq("enhanced textcolor 'red'")

    text.font_size(14)

    text.repr.should eq("enhanced textcolor 'red' font ',14'")

    text.font_name("Arial")

    text.repr.should eq("enhanced textcolor 'red' font 'Arial,14'")

    text.enhanced(false)

    text.repr.should eq("noenhanced textcolor 'red' font 'Arial,14'")
  end
end
