require "../spec_helper"

describe Cryplot::Legend do
  it "test Legend" do
    default_legend = Cryplot::Legend.new
      .at_top_right
      .title("")
      .display_expand_width_by(Cryplot::Consts::DEFAULT_LEGEND_FRAME_EXTRA_WIDTH)
      .display_expand_height_by(Cryplot::Consts::DEFAULT_LEGEND_FRAME_EXTRA_HEIGHT)
      .display_symbol_length(Cryplot::Consts::DEFAULT_LEGEND_SAMPLE_LENGTH)
      .display_spacing(Cryplot::Consts::DEFAULT_LEGEND_SPACING)
      .display_vertical
      .display_labels_after_symbols
      .display_justify_left
      .display_start_from_first
      .opaque

    legend = Cryplot::Legend.new

    legend.repr.should eq(default_legend.repr)

    legend.at_outside_bottom_right
      .transparent

    # Customize frame
    legend.frame_show
      .frame_line_color("purple")
      .frame_line_type(3)
      .frame_line_width(4)

    # Customize display of labels and symbols
    legend.display_horizontal
      .display_horizontal_max_cols(5)
      .display_symbol_length(7)
      .display_expand_height_by(11)
      .display_expand_width_by(13)
      .display_start_from_last
      .display_labels_after_symbols
      .display_justify_right

    # Customize title
    legend.title("Hello")
      .title_font_name("Arial")
      .title_font_size(17)
      .title_text_color("blue")
      .title_left
      .text_color("red").font_name("Times").font_size(19)

    legend.repr.should eq(
      "set key bmargin right noopaque horizontal Right invert " +
      "reverse width 13 height 11 samplen 7 spacing 1 enhanced " +
      "textcolor 'red' font 'Times,19' title 'Hello' enhanced " +
      "textcolor 'blue' font 'Arial,17' left box linetype 3 " +
      "linewidth 4 linecolor 'purple' maxrows auto maxcols 5")
  end
end
