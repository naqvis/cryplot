require "../spec_helper"

describe Cryplot::HistogramStyle do
  it "test Histogram style" do
    specs = Cryplot::HistogramStyle.new

    specs.repr.should eq("set style histogram")

    specs.clustered
    specs.repr.should eq("set style histogram clustered")

    specs.clustered_with_gap(0.92)
    specs.repr.should eq("set style histogram clustered gap 0.92")

    specs.error_bars
    specs.repr.should eq("set style histogram errorbars")

    specs.error_bars_with_gap(0.56)
    specs.repr.should eq("set style histogram errorbars gap 0.56")

    specs.error_bars_with_line_width(1.6)
    specs.repr.should eq("set style histogram errorbars gap 0.56 linewidth 1.6")

    specs.row_stacked
    specs.repr.should eq("set style histogram rowstacked")

    specs.column_stacked
    specs.repr.should eq("set style histogram columnstacked")
  end
end
