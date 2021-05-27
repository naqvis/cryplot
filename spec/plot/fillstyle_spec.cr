require "../spec_helper"

describe Cryplot::FillStyle do
  it "test fillstyle" do
    specs = Cryplot::FillStyle.new
    specs.repr.should eq("")

    specs.empty
    specs.repr.should eq("set style fill empty")

    specs.solid
    specs.repr.should eq("set style fill solid")

    specs.intensity(0.83)
    specs.repr.should eq("set style fill solid 0.83")

    specs.transparent
    specs.repr.should eq("set style fill transparent solid 0.83")

    specs.empty
    specs.intensity(0.24)
    specs.repr.should eq("set style fill transparent solid 0.24")

    specs.empty
    specs.transparent
    specs.repr.should eq("set style fill empty")

    specs.pattern(23)
    specs.repr.should eq("set style fill transparent pattern 23")

    specs.transparent(false)
    specs.repr.should eq("set style fill pattern 23")

    specs.border_show
    specs.repr.should eq("set style fill pattern 23 border")

    specs.border_line_color("red")
    specs.repr.should eq("set style fill pattern 23 border linecolor 'red'")

    specs.border_line_width(2)
    specs.repr.should eq("set style fill pattern 23 border linecolor 'red' linewidth 2")

    specs.border_hide
    specs.repr.should eq("set style fill pattern 23 noborder")

    specs.empty
    specs.intensity(0.7)
    specs.repr.should eq("set style fill solid 0.7 noborder")

    specs.intensity(1.7)
    specs.repr.should eq("set style fill solid 1 noborder")

    specs.intensity(-0.2)
    specs.repr.should eq("set style fill solid 0 noborder")
  end
end
