require "../spec_helper"

describe Cryplot::Title do
  it "test Title" do
    specs = Cryplot::Title.new

    specs.title("Hello")
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040'")

    specs.title_shift_along_x(1)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset 1, 0")

    specs.title_shift_along_y(2)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset 1, 2")

    specs.title_shift_along_graph_x(0.3)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset graph 0.3, 2")

    specs.title_shift_along_graph_y(0.4)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset graph 0.3, graph 0.4")

    specs.title_shift_along_screen_x(0.5)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset screen 0.5, graph 0.4")

    specs.title_shift_along_screen_y(0.6)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' offset screen 0.5, screen 0.6")

    specs.title_font_name("Arial")
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' font 'Arial,' offset screen 0.5, screen 0.6")

    specs.title_font_size(13)
    specs.repr.should eq("title 'Hello' enhanced textcolor '#404040' font 'Arial,13' offset screen 0.5, screen 0.6")
  end
end
