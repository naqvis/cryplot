require "../spec_helper"

describe Cryplot::Offset do
  it "test Offset" do
    offset = Cryplot::Offset.new

    offset.shift_along_x(1)

    offset.repr.should eq("offset 1, 0")

    offset.shift_along_y(2)

    offset.repr.should eq("offset 1, 2")

    offset.shift_along_graph_x(0.3)

    offset.repr.should eq("offset graph 0.3, 2")

    offset.shift_along_graph_y(0.4)

    offset.repr.should eq("offset graph 0.3, graph 0.4")

    offset.shift_along_screen_x(0.5)

    offset.repr.should eq("offset screen 0.5, graph 0.4")

    offset.shift_along_screen_y(0.6)

    offset.repr.should eq("offset screen 0.5, screen 0.6")
  end
end
