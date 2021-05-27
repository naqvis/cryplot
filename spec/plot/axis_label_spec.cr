require "../spec_helper"

describe Cryplot::AxisLabel do
  it "Test Axis Label" do
    axis = Cryplot::AxisLabel.new("x")
      .text("Distance")
      .text_color("red")
      .font_size(14)
      .font_name("Arial")

    expected = "set xlabel 'Distance' enhanced textcolor 'red' font 'Arial,14'"
    axis.repr.should eq(expected)

    axis.rotate_by(67)
    axis.repr.should eq(expected + " rotate by 67")

    axis.rotate_by(90)
    axis.repr.should eq(expected + " rotate by 90")

    axis.rotate_axis_parallel
    axis.repr.should eq(expected + " rotate parallel")

    axis.rotate_none
    axis.repr.should eq(expected + " norotate")
  end
end
