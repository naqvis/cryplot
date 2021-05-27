require "../spec_helper"

describe Cryplot::Show do
  it "test Show" do
    visibility = Cryplot::Show.new
    visibility.repr.should eq("")

    visibility.show(false)
    visibility.repr.should eq("no")

    visibility.show
    visibility.repr.should eq("")

    visibility.hide
    visibility.repr.should eq("no")
  end
end
