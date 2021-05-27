require "../spec_helper"

describe Cryplot::Point do
  it "test Point" do
    point = Cryplot::Point.new

    point.repr.should eq("")

    point.point_type(8)
    point.repr.should eq("pointtype 8")

    point.point_size(5)
    point.repr.should eq("pointtype 8 pointsize 5")
  end
end
