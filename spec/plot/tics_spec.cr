require "../spec_helper"

describe Cryplot::Tics do
  it "test Tics" do
    default_tics = Cryplot::Tics.new
      .along_border
      .mirror(Cryplot::Consts::DEFAULT_TICS_MIRROR)
      .outside_graph
      .rotate(Cryplot::Consts::DEFAULT_TICS_ROTATE)
      .stack_front
      .scale_major_by(Cryplot::Consts::DEFAULT_TICS_SCALE_MAJOR_BY)
      .scale_minor_by(Cryplot::Consts::DEFAULT_TICS_SCALE_MINOR_BY)

    tics = Cryplot::Tics.new
    tics.repr.should eq(default_tics.repr)

    tics.along_axis
    tics.repr.should eq("set tics axis nomirror out scale 0.5,0.25 norotate enhanced textcolor '#404040' front")

    tics.along_border
    tics.repr.should eq("set tics border nomirror out scale 0.5,0.25 norotate enhanced textcolor '#404040' front")

    tics.mirror
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 norotate enhanced textcolor '#404040' front")

    tics.inside_graph
    tics.repr.should eq("set tics border mirror in scale 0.5,0.25 norotate enhanced textcolor '#404040' front")

    tics.outside_graph
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 norotate enhanced textcolor '#404040' front")

    tics.rotate
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 rotate enhanced textcolor '#404040' front")

    tics.rotate_by(42)
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 rotate by 42 enhanced textcolor '#404040' front")

    tics.stack_front
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 rotate by 42 enhanced textcolor '#404040' front")

    tics.stack_back
    tics.repr.should eq("set tics border mirror out scale 0.5,0.25 rotate by 42 enhanced textcolor '#404040' back")

    tics.scale_by(1.2)
    tics.repr.should eq("set tics border mirror out scale 1.2,0.25 rotate by 42 enhanced textcolor '#404040' back")

    tics.scale_major_by(5.6)
    tics.repr.should eq("set tics border mirror out scale 5.6,0.25 rotate by 42 enhanced textcolor '#404040' back")

    tics.scale_minor_by(7.9)
    tics.repr.should eq("set tics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' back")

    tics.format("%4.2f")
    tics.repr.should eq("set tics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' back")

    tics.font_name("Arial")
    tics.repr.should eq("set tics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' font 'Arial,' '%4.2f' back")

    tics.font_size(14)
    tics.repr.should eq("set tics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' font 'Arial,14' '%4.2f' back")

    tics.hide
    tics.repr.should eq("unset tics")
  end
end
