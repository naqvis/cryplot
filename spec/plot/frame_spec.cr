require "../spec_helper"

describe Cryplot::Frame do
  it "test Frame" do
    default_framespecs = Cryplot::Frame.new
      .frame_show(Cryplot::Consts::DEFAULT_LEGEND_FRAME_SHOW)
      .frame_line_width(Cryplot::Consts::DEFAULT_LEGEND_FRAME_LINEWIDTH)
      .frame_line_color(Cryplot::Consts::DEFAULT_LEGEND_FRAME_LINECOLOR)
      .frame_line_type(Cryplot::Consts::DEFAULT_LEGEND_FRAME_LINETYPE)

    framespecs = Cryplot::Frame.new
    framespecs.repr.should eq(default_framespecs.repr)

    framespecs.frame_show
      .frame_line_style(11)
      .frame_line_type(67)
      .frame_line_width(3)
      .frame_line_color("orange")
      .frame_dash_type(2)
    framespecs.repr.should eq("box linestyle 11 linetype 67 linewidth 3 linecolor 'orange' dashtype 2")

    framespecs.frame_hide
    framespecs.repr.should eq("nobox")
  end
end
