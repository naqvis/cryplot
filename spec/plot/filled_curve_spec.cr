require "../spec_helper"

describe Cryplot::FilledCurve do
  it "test filled curve" do
    spec = Cryplot::FilledCurve.new

    spec.repr.should eq("")

    spec.above
    spec.repr.should eq("above")

    spec.below
    spec.repr.should eq("below")
  end
end
