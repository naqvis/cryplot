require "../spec_helper"

describe Cryplot::Border do
  it "test border" do
    defaultborder = Cryplot::Border.new
      .left
      .bottom
      .line_type(Cryplot::Consts::DEFAULT_BORDER_LINETYPE)
      .line_width(Cryplot::Consts::DEFAULT_BORDER_LINEWIDTH)
      .line_color(Cryplot::Consts::DEFAULT_BORDER_LINECOLOR)
      .front

    border = Cryplot::Border.new

    border.repr.should eq(defaultborder.repr)

    border
      .right
      .top
      .line_type(5)
      .line_width(7)
      .line_color("red")
      .back

    border.repr.should eq("set border 15 back linetype 5 linewidth 7 linecolor 'red'")

    border.behind
    border.repr.should eq("set border 15 behind linetype 5 linewidth 7 linecolor 'red'")
  end
end
