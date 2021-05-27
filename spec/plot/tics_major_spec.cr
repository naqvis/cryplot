require "../spec_helper"

describe Cryplot::MajorTics do
  it "test MajorTics" do
    default_xtics = Cryplot::MajorTics.new("x")
      .along_border
      .mirror(Cryplot::Consts::DEFAULT_TICS_MIRROR)
      .outside_graph
      .rotate(Cryplot::Consts::DEFAULT_TICS_ROTATE)
      .scale_major_by(Cryplot::Consts::DEFAULT_TICS_SCALE_MAJOR_BY)
      .scale_minor_by(Cryplot::Consts::DEFAULT_TICS_SCALE_MINOR_BY)

    xtics = Cryplot::MajorTics.new("x")
    xtics.repr.should eq(default_xtics.repr)

    xtics.along_axis
    xtics.repr.should eq("set xtics axis nomirror out scale 0.5,0.25 norotate enhanced textcolor '#404040'")

    xtics.along_border
    xtics.repr.should eq("set xtics border nomirror out scale 0.5,0.25 norotate enhanced textcolor '#404040'")

    xtics.mirror
    xtics.repr.should eq("set xtics border mirror out scale 0.5,0.25 norotate enhanced textcolor '#404040'")

    xtics.inside_graph
    xtics.repr.should eq("set xtics border mirror in scale 0.5,0.25 norotate enhanced textcolor '#404040'")

    xtics.outside_graph
    xtics.repr.should eq("set xtics border mirror out scale 0.5,0.25 norotate enhanced textcolor '#404040'")

    xtics.rotate
    xtics.repr.should eq("set xtics border mirror out scale 0.5,0.25 rotate enhanced textcolor '#404040'")

    xtics.rotate_by(42)
    xtics.repr.should eq("set xtics border mirror out scale 0.5,0.25 rotate by 42 enhanced textcolor '#404040'")

    xtics.scale_by(1.2)
    xtics.repr.should eq("set xtics border mirror out scale 1.2,0.25 rotate by 42 enhanced textcolor '#404040'")

    xtics.scale_major_by(5.6)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,0.25 rotate by 42 enhanced textcolor '#404040'")

    xtics.scale_minor_by(7.9)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040'")

    xtics.format("%4.2f")
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f'")

    xtics.increment(1.2345)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' 1.2345")

    xtics.start(0.345)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' 0.345, 1.2345")

    xtics.end(5.652)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' 0.345, 1.2345, 5.652")

    xtics.interval(0.234, 0.899, 3.45)
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' 0.234, 0.899, 3.45")

    xtics.at([0.1, 0.2, 0.3, 0.4])
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' (0.1, 0.2, 0.3, 0.4)")

    xtics.at([0.1, 0.2, 0.3, 0.4], ["A", "", "C", "F"])
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' ('A' 0.1, '' 0.2, 'C' 0.3, 'F' 0.4)")

    xtics.add([1.1, 1.2, 1.3, 1.4])
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' ('A' 0.1, '' 0.2, 'C' 0.3, 'F' 0.4) add (1.1, 1.2, 1.3, 1.4)")

    xtics.add([2.1, 2.2, 2.3, 2.4], ["Z", "U", "V", "X"])
    xtics.repr.should eq("set xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' ('A' 0.1, '' 0.2, 'C' 0.3, 'F' 0.4) add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.logscale
    xtics.repr.should eq("set logscale x 10\nset xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' ('A' 0.1, '' 0.2, 'C' 0.3, 'F' 0.4) add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.logscale(2)
    xtics.repr.should eq("set logscale x 2\nset xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' ('A' 0.1, '' 0.2, 'C' 0.3, 'F' 0.4) add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.automatic
    xtics.repr.should eq("set logscale x 2\nset xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' '%4.2f' add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.font_name("Arial")
    xtics.repr.should eq("set logscale x 2\nset xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' font 'Arial,' '%4.2f' add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.font_size(16)
    xtics.repr.should eq("set logscale x 2\nset xtics border mirror out scale 5.6,7.9 rotate by 42 enhanced textcolor '#404040' font 'Arial,16' '%4.2f' add ('Z' 2.1, 'U' 2.2, 'V' 2.3, 'X' 2.4)")

    xtics.automatic
    xtics.start(1.0)

    expect_raises(Exception) do
      xtics.repr # method start has been called, but not method increment
    end
    xtics.automatic
    xtics.end(2.0)
    expect_raises(Exception) do
      xtics.repr # method end has been called, but not methods start and increment
    end

    xtics.automatic
    xtics.start(1.0)
    xtics.end(2.0)
    expect_raises(Exception) do
      xtics.repr # method end has been called, but not method increment
    end

    xtics.automatic
    xtics.start(1.0)
    xtics.end(2.0)
    xtics.increment(0.1)
    xtics.repr # methods start, increment and end have been called - OK!

    expect_raises(Exception) do
      Cryplot::MajorTics.new("") # constructor has been called with empty string
    end
    xtics.hide
    xtics.repr.should eq("unset xtics")
  end
end
