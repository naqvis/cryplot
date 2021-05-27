require "../spec_helper"

describe Cryplot::Fill do
  it "test fill" do
    specs = Cryplot::Fill.new

    specs.repr.should eq("")

    specs.fill_empty
    specs.repr.should eq("fillstyle empty")

    specs.fill_solid
    specs.repr.should eq("fillstyle solid")

    specs.fill_intensity(0.83)
    specs.repr.should eq("fillstyle solid 0.83")

    specs.fill_transparent
    specs.repr.should eq("fillstyle transparent solid 0.83")

    specs.fill_empty
    specs.fill_intensity(0.24)
    specs.repr.should eq("fillstyle transparent solid 0.24")

    specs.fill_empty
    specs.fill_transparent
    specs.repr.should eq("fillstyle empty")

    specs.fill_pattern(23)
    specs.repr.should eq("fillstyle transparent pattern 23")

    specs.fill_transparent(false)
    specs.repr.should eq("fillstyle pattern 23")

    specs.fill_color("white")
    specs.repr.should eq("fillcolor 'white' fillstyle pattern 23")

    specs.border_show
    specs.repr.should eq("fillcolor 'white' fillstyle pattern 23 border")

    specs.border_line_color("red")
    specs.repr.should eq("fillcolor 'white' fillstyle pattern 23 border linecolor 'red'")

    specs.border_line_width(2)
    specs.repr.should eq("fillcolor 'white' fillstyle pattern 23 border linecolor 'red' linewidth 2")

    specs.border_hide
    specs.repr.should eq("fillcolor 'white' fillstyle pattern 23 noborder")

    specs.fill_empty
    specs.fill_intensity(0.7)
    specs.repr.should eq("fillcolor 'white' fillstyle solid 0.7 noborder")

    specs.fill_intensity(1.7)
    specs.repr.should eq("fillcolor 'white' fillstyle solid 1 noborder")

    specs.fill_intensity(-0.2)
    specs.repr.should eq("fillcolor 'white' fillstyle solid 0 noborder")
  end
end
