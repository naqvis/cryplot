require "../spec_helper"

describe Cryplot::Line do
  it "test Line" do
    line = Cryplot::Line.new
    line.repr.should eq("")

    line.line_style(5)
    line.repr.should eq("linestyle 5")

    line.line_type(8)
    line.repr.should eq("linestyle 5 linetype 8")

    line.line_width(2)
    line.repr.should eq("linestyle 5 linetype 8 linewidth 2")

    line.line_color("orange")
    line.repr.should eq("linestyle 5 linetype 8 linewidth 2 linecolor 'orange'")

    line.dash_type(2)
    line.repr.should eq("linestyle 5 linetype 8 linewidth 2 linecolor 'orange' dashtype 2")

    line.line_style(11)
    line.line_type(67)
    line.line_width(3)
    line.line_color("blue")
    line.dash_type(7)

    line.repr.should eq("linestyle 11 linetype 67 linewidth 3 linecolor 'blue' dashtype 7")
  end
end
