require "../spec_helper"

describe Cryplot::Grid do
  it "test Grid" do
    grid = Cryplot::Grid.new

    grid.repr.should eq("unset grid")

    grid
      .show
      .front
      .line_color("ocean")
      .line_width(1)
      .line_type(3)
      .dash_type(5)

    grid.repr.should eq("set grid front linetype 3 linewidth 1 linecolor 'ocean' dashtype 5")

    grid.xtics_major_bottom.front.line_color("red")
    grid.xtics_major_top.back.line_color("black")
    grid.ytics_major_left.front.line_color("purple")
    grid.ytics_major_right.back.line_color("green")
    grid.xtics_minor_bottom.front.line_color("white")
    grid.xtics_minor_top.back.line_color("gray")
    grid.ytics_minor_left.front.line_color("orange")
    grid.ytics_minor_right.back.line_color("lime")

    grid.repr.should eq("set grid front linetype 3 linewidth 1 linecolor 'ocean' dashtype 5\n" +
                        "set grid xtics front linetype 1 linewidth 1 linecolor 'red' dashtype 0\n" +
                        "set grid x2tics back linetype 1 linewidth 1 linecolor 'black' dashtype 0\n" +
                        "set grid ytics front linetype 1 linewidth 1 linecolor 'purple' dashtype 0\n" +
                        "set grid y2tics back linetype 1 linewidth 1 linecolor 'green' dashtype 0\n" +
                        "set grid mxtics front , linetype 1 linewidth 1 linecolor 'white' dashtype 0\n" +
                        "set grid mx2tics back , linetype 1 linewidth 1 linecolor 'gray' dashtype 0\n" +
                        "set grid mytics front , linetype 1 linewidth 1 linecolor 'orange' dashtype 0\n" +
                        "set grid my2tics back , linetype 1 linewidth 1 linecolor 'lime' dashtype 0")
  end
end
