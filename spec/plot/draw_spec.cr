require "../spec_helper"

describe Cryplot::Draw do
  it "test draw" do
    specs = Cryplot::Draw.new("'file.dat'", "1:2", "lines")

    specs.repr.should eq("'file.dat' using 1:2 with lines linewidth 2")

    specs.label("SuperData")
    specs.repr.should eq("'file.dat' using 1:2 title 'SuperData' with lines linewidth 2")

    specs.label_default
    specs.repr.should eq("'file.dat' using 1:2 with lines linewidth 2")

    specs.label_from_column_header
    specs.repr.should eq("'file.dat' using 1:2 title columnheader with lines linewidth 2")

    specs.label_from_column_header(3)
    specs.repr.should eq("'file.dat' using 1:2 title columnheader(3) with lines linewidth 2")

    specs.label("OnlyData")
    specs.repr.should eq("'file.dat' using 1:2 title 'OnlyData' with lines linewidth 2")

    specs.line_width(3)
    specs.line_color("orange")
    specs.repr.should eq("'file.dat' using 1:2 title 'OnlyData' with lines linewidth 3 linecolor 'orange'")

    specs.ytics(9)
    specs.repr.should eq("'file.dat' using 1:2:ytic(stringcolumn(9)) title 'OnlyData' with lines linewidth 3 linecolor 'orange'")

    specs.xtics("Country")
    specs.repr.should eq("'file.dat' using 1:2:xtic(stringcolumn('Country')):ytic(stringcolumn(9)) title 'OnlyData' with lines linewidth 3 linecolor 'orange'")
  end
end
