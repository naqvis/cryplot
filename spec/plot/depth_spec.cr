require "../spec_helper"

describe Cryplot::Depth do
  it "test depth" do
    default = Cryplot::Depth.new
      .back

    depth = Cryplot::Depth.new

    depth.repr.should eq(default.repr)

    depth.front
    depth.repr.should eq("front")

    depth.back
    depth.repr.should eq("back")

    depth.behind
    depth.repr.should eq("behind")
  end
end
