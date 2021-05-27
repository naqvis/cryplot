require "../spec_helper"

describe Cryplot::MinorTics do
  it "test MinorTics" do
    xtics = Cryplot::MinorTics.new("x")
    xtics.repr.should eq("set mxtics")

    xtics.number(5)
    xtics.repr.should eq("set mxtics 6")

    xtics.automatic
    xtics.repr.should eq("set mxtics")

    xtics.hide
    xtics.repr.should eq("unset mxtics")
  end
end
