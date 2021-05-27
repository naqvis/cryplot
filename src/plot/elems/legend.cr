require "./text"
require "./show"
require "./title"
require "./frame"
require "../consts"

module Cryplot
  # Class used to specific options for legend
  class Legend
    include TextMixin(Legend)
    include ShowMixin(Legend)
    include TitleMixin(Legend)
    include FrameMixin(Legend)

    # The place at which the legend is displayed.
    @placement : String = ""
    # The opaque option of the legend.
    @opaque : String = ""
    # The alignment of the labels (either along the horizontal or vertical).
    @alignment : String = ""
    # The reverse option for the labels (if they printed on the left or right sides within the legend).
    @reverse : String = ""
    # The invert option of the labels (if they are printed from first to last or the other way around).
    @invert : String = ""
    # The justification mode of the labels in the legend (Left or Right gnuplot options).
    @justification : String = ""
    # The location of the legend title (left, center, right).
    @title_loc : String = "left"
    # The width increment of the legend frame.
    @width_increment : Int32 = 0
    # The height increment of the legend frame.
    @height_increment : Int32 = 0
    # The length of the samples in the legend.
    @samplen : Int32 = 0
    # The spacing between the titles in the legend.
    @spacing : Int32 = 0
    # The maximum number of rows of titles in the legend.
    @maxrows : String = "auto"
    # The maximum number of rows of titles in the legend.
    @maxcols : String = "auto"

    def initialize
      super
      show
      at_top_right
      title("")
      display_expand_width_by(Consts::DEFAULT_LEGEND_FRAME_EXTRA_WIDTH)
      display_expand_height_by(Consts::DEFAULT_LEGEND_FRAME_EXTRA_HEIGHT)
      display_symbol_length(Consts::DEFAULT_LEGEND_SAMPLE_LENGTH)
      display_spacing(Consts::DEFAULT_LEGEND_SPACING)
      display_vertical()
      display_labels_after_symbols()
      display_justify_left()
      display_start_from_first()
      opaque()
    end

    # Set the background of the legend box to be opaque.
    def opaque
      @opaque = "opaque"
      self
    end

    # Set the background of the legend box to be transparent.
    def transparent
      @opaque = "noopaque"
      self
    end

    # Place the legend on the inside of the plot at its left side.
    def at_left
      @placement = "inside left"
      self
    end

    # Place the legend on the inside of the plot at its right side.
    def at_right
      @placement = "inside right"
      self
    end

    # Place the legend on the inside of the plot at its center.
    def at_center
      @placement = "inside center"
      self
    end

    # Place the legend on the inside of the plot at its top side.
    def at_top
      @placement = "inside center top"
      self
    end

    # Place the legend on the inside of the plot at its top-left corner.
    def at_top_left
      @placement = "inside left top"
      self
    end

    # Place the legend on the inside of the plot at its top-right corner.
    def at_top_right
      @placement = "inside right top"
      self
    end

    # Place the legend on the inside of the plot at its bottom side.
    def at_bottom
      @placement = "inside center bottom"
      self
    end

    # Place the legend on the inside of the plot at its bottom-left corner.
    def at_bottom_left
      @placement = "inside left bottom"
      self
    end

    # Place the legend on the inside of the plot at its bottom-right corner.
    def at_bottom_right
      @placement = "inside right bottom"
      self
    end

    # Place the legend on the outside of the plot at its left side.
    def at_outside_left
      @placement = "lmargin center"
      self
    end

    # Place the legend on the outside of the plot at its left-top corner.
    def at_outside_left_top
      @placement = "lmargin top"
      self
    end

    # Place the legend on the outside of the plot at its left-bottom corner.
    def at_outside_left_bottom
      @placement = "lmargin bottom"
      self
    end

    # Place the legend on the outside of the plot at its right side.
    def at_outside_right
      @placement = "rmargin center"
      self
    end

    # Place the legend on the outside of the plot at its right-top corner.
    def at_outside_right_top
      @placement = "rmargin top"
      self
    end

    # Place the legend on the outside of the plot at its right-bottom corner.
    def at_outside_right_bottom
      @placement = "rmargin bottom"
      self
    end

    # Place the legend on the outside of the plot at its bottom side.
    def at_outside_bottom
      @placement = "bmargin center"
      self
    end

    # Place the legend on the outside of the plot at its bottom-left corner.
    def at_outside_bottom_left
      @placement = "bmargin left"
      self
    end

    # Place the legend on the outside of the plot at its bottom-right corner.
    def at_outside_bottom_right
      @placement = "bmargin right"
      self
    end

    # Place the legend on the outside of the plot at its top side.
    def at_outside_top
      @placement = "tmargin center"
      self
    end

    # Place the legend on the outside of the plot at its top-left corner.
    def at_outside_top_left
      @placement = "tmargin left"
      self
    end

    # Place the legend on the outside of the plot at its top-right corner.
    def at_outside_top_right
      @placement = "tmargin right"
      self
    end

    # Place the legend title on the left.
    def title_left
      @title_loc = "left"
      self
    end

    # Place the legend title on the center.
    def title_center
      @title_loc = "center"
      self
    end

    # Place the legend title on the right.
    def title_right
      @title_loc = "right"
      self
    end

    # Set the legend entries to be displayed along the vertical (in columns).
    def display_vertical
      @alignment = "vertical"
      self
    end

    # Set the number of rows that trigger a new column to be created in the legend (when using vertical display).
    def display_vertical_max_rows(value : Int32)
      @maxrows = value.to_s
      self
    end

    # Set the legend entries to be displayed along the horizontal (in rows).
    def display_horizontal
      @alignment = "horizontal"
      self
    end

    # Set the number of columns that trigger a new row to be created in the legend (when using horizontal display).
    def display_horizontal_max_cols(value : Int32)
      @maxcols = value.to_s
      self
    end

    # Set the labels in the legend entries to appear before their corresponding symbols (on the left).
    def display_labels_before_symbols
      @reverse = "noreverse"
      self
    end

    # Set the labels in the legend entries to appear after their corresponding symbols (on the right).
    def display_labels_after_symbols
      @reverse = "reverse"
      self
    end

    # Set the legend labels to be left justified.
    def display_justify_left
      @justification = "Left"
      self
    end

    # Set the legend labels to be right justified.
    def display_justify_right
      @justification = "Right"
      self
    end

    # Set the legend entries to be displayed in the order from first to last.
    def display_start_from_first
      @invert = "noinvert"
      self
    end

    # Set the legend entries to be displayed in the order from last to first.
    def display_start_from_last
      @invert = "invert"
      self
    end

    # Set the spacing between the titles in the legend.
    def display_spacing(value : Int32)
      @spacing = value
      self
    end

    # Set the width increment/decrement of the legend frame to either enlarge or reduce its width.
    def display_expand_width_by(value : Int32)
      @width_increment = value
      self
    end

    # Set the height increment/decrement of the legend frame to either enlarge or reduce its height.
    def display_expand_height_by(value : Int32)
      @height_increment = value
      self
    end

    # Set the length of the samples used to generate the symbols in the legend entries.
    def display_symbol_length(value : Int32)
      @samplen = value
      self
    end

    def repr : String
      show = show_repr
      return "unset key" if show == "no"
      title = title_repr
      title += " #{@title_loc}" if title.size > 0 #  attach left|center|right to title (e.g. title 'Legend' right)
      String.build do |sb|
        sb << "set key "
        sb << @placement << " " << @opaque << " "
        sb << @alignment << " "
        sb << @justification << " "
        sb << @invert << " "
        sb << @reverse << " "
        sb << "width #{@width_increment} "
        sb << "height #{@height_increment} "
        sb << "samplen #{@samplen} "
        sb << "spacing #{@spacing} "
        sb << text_repr << " "
        sb << title << " "
        sb << frame_repr << " "
        sb << "maxrows #{@maxrows} "
        sb << "maxcols #{@maxcols} "
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
