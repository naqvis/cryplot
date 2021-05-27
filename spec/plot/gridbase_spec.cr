require "../spec_helper"

describe Cryplot::GridBase do
  it "test GridBase" do
    defaultgrid = Cryplot::GridBase.new
      .show(true)
      .back
      .line_color(Cryplot::Consts::DEFAULT_GRID_LINECOLOR)
      .line_width(Cryplot::Consts::DEFAULT_GRID_LINEWIDTH)
      .line_type(Cryplot::Consts::DEFAULT_GRID_LINETYPE)
      .dash_type(Cryplot::Consts::DEFAULT_GRID_DASHTYPE)

    grid = Cryplot::GridBase.new
    grid.repr.should eq(defaultgrid.repr)

    grid
      .show
      .front
      .line_style(7)
      .line_type(4)
      .line_width(5)
      .line_color("red")
      .dash_type(9)

    grid.repr.should eq("set grid front linestyle 7 linetype 4 linewidth 5 linecolor 'red' dashtype 9")

    majortics = true
    minortics = false

    xtics_major_grid = Cryplot::GridBase.new("xtics", majortics)
    xtics_major_grid.show(true)
    xtics_major_grid.front
    xtics_major_grid.line_style(2)
    xtics_major_grid.line_type(6)
    xtics_major_grid.line_width(1)
    xtics_major_grid.line_color("black")
    xtics_major_grid.dash_type(3)

    xtics_major_grid.repr.should eq("set grid xtics front linestyle 2 linetype 6 linewidth 1 linecolor 'black' dashtype 3")

    xtics_major_grid.show(false)

    xtics_major_grid.repr.should eq("set grid noxtics")

    ytics_minor_grid = Cryplot::GridBase.new("mytics", minortics)
      .show(true)
      .back
      .line_style(6)
      .line_type(2)
      .line_width(11)
      .line_color("purple")
      .dash_type(13)

    # Note the comma below. This is because the line properties correspond to grid lines of minor tics. See documentation of `set grid` in Gnuplot manual.
    ytics_minor_grid.repr.should eq("set grid mytics back , linestyle 6 linetype 2 linewidth 11 linecolor 'purple' dashtype 13")

    ytics_minor_grid.show(false)

    ytics_minor_grid.repr.should eq("set grid nomytics")
  end
end
