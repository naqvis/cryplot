require "./spec_helper"

describe Cryplot::Gnuplot do
  it "Test helper methods" do
    Cryplot::Gnuplot.title("Something").should eq("'Something'")
    Cryplot::Gnuplot.title("columnheader").should eq("columnheader")

    Cryplot::Gnuplot.cleanpath("build/:*?!\"<>|xy.svg").should eq("build/xy.svg")
    Cryplot::Gnuplot.cleanpath("build:*?!\"<>|/xy.svg").should eq("build/xy.svg")
    Cryplot::Gnuplot.cleanpath("build:*?!\"<>|/xy:*?!\"<>|.svg").should eq("build/xy.svg")
  end
end
