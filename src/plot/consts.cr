module Cryplot
  alias Vec = Array(Float64)
  alias Strings = Array(String)

  PI                   = 3.14159265359
  GOLDEN_RATIO         =      1.618034
  GOLDEN_RATIO_INVERSE = 1.0 / GOLDEN_RATIO
  INCH_TO_POINTS       = 72.0 # based on pdfcairo terminal conversion
  POINT_TO_INCHES      = 1.0 / INCH_TO_POINTS

  NAN               = Float64::NAN # can be used to indicate missing values in a numeric vector
  MISSING_INDICATOR = "\"?\""      # The string used to indicate missing y values.

  # Extension formats supported when saving a plot to a file
  enum Extension
    EMF
    PNG
    SVG
    PDF
    EPS
  end

  # :nodoc:
  module Consts
    DEFAULT_FIGURE_HEIGHT            = 200 # this is equivalent to 6 inches if 1 in = 72 points
    DEFAULT_FIGURE_WIDTH             = DEFAULT_FIGURE_HEIGHT * GOLDEN_RATIO
    DEFAULT_FIGURE_BOXWIDTH_RELATIVE = 0.9

    DEFAULT_PALETTE = Cryplot::Palette::Dark2

    DEFAULT_TEXTCOLOR = "#404040"

    DEFAULT_LINEWIDTH = 2
    DEFAULT_POINTSIZE = 2

    DEFAULT_FILL_INTENSITY        = 1.0
    DEFAULT_FILL_TRANSPARENCY     = false
    DEFAULT_FILL_BORDER_LINEWIDTH = 2

    DEFAULT_BORDER_LINECOLOR = "#404040"
    DEFAULT_BORDER_LINETYPE  = 1
    DEFAULT_BORDER_LINEWIDTH = 2

    DEFAULT_GRID_LINECOLOR = "#d6d7d9"
    DEFAULT_GRID_LINEWIDTH = 1
    DEFAULT_GRID_LINETYPE  = 1
    DEFAULT_GRID_DASHTYPE  = 0

    DEFAULT_LEGEND_TEXTCOLOR          = DEFAULT_TEXTCOLOR
    DEFAULT_LEGEND_FRAME_SHOW         = false
    DEFAULT_LEGEND_FRAME_LINECOLOR    = DEFAULT_GRID_LINECOLOR
    DEFAULT_LEGEND_FRAME_LINEWIDTH    = DEFAULT_GRID_LINEWIDTH
    DEFAULT_LEGEND_FRAME_LINETYPE     = 1
    DEFAULT_LEGEND_FRAME_EXTRA_WIDTH  = 0
    DEFAULT_LEGEND_FRAME_EXTRA_HEIGHT = 1
    DEFAULT_LEGEND_SPACING            = 1
    DEFAULT_LEGEND_SAMPLE_LENGTH      = 4

    DEFAULT_TICS_MIRROR         = false
    DEFAULT_TICS_ROTATE         = false
    DEFAULT_TICS_SCALE_MAJOR_BY = 0.50
    DEFAULT_TICS_SCALE_MINOR_BY = 0.25
    DEFAULT_TICS_MINOR_SHOW     = false
  end
end
