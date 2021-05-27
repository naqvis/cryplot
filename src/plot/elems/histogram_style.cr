require "./base"

module Cryplot
  # class used to specify histogram style options
  class HistogramStyle
    include BaseMixin(HistogramStyle)

    # The type of the histogram (clustered, errorbars, rowstacked, columnstacked).
    @type : String

    # The gap size (for clustered)
    @gap_clustered : String

    # The gap size (for errorbars)
    @gap_errorbars : String

    # The line width (applicable only to errorbars)
    @linewidth : String

    def initialize
      @type = ""
      @gap_clustered = ""
      @gap_errorbars = ""
      @linewidth = ""
    end

    # Set the histogram style to be clustered.
    def clustered
      @type = "clustered"
      self
    end

    # Set the histogram style to be clustered with a given gap size.
    def clustered_with_gap(value : Float64)
      @type = "clustered"
      @gap_clustered = "gap #{value}"
      self
    end

    # Set the histogram style to be stacked with groups formed using data along rows.
    def row_stacked
      @type = "rowstacked"
      self
    end

    # Set the histogram style to be stacked with groups formed using data along columns.
    def column_stacked
      @type = "columnstacked"
      self
    end

    # Set the histogram style to be with error bars.
    def error_bars
      @type = "errorbars"
      self
    end

    # Set the histogram style to be with error bars and also set its gap size.
    def error_bars_with_gap(value : Float64)
      @type = "errorbars"
      @gap_errorbars = "gap #{value}"
      self
    end

    # Set the histogram style to be with error bars and also set its line width.
    def error_bars_with_line_width(value : Float64)
      @type = "errorbars"
      @linewidth = "linewidth #{value}"
      self
    end

    def repr : String
      String.build do |sb|
        sb << "set style histogram" << " "
        sb << @type << " "
        sb << "#{@gap_clustered} " if @type == "clustered"
        sb << "#{@gap_errorbars} " if @type == "errorbars"
        sb << "#{@linewidth} " if @type == "errorbars"
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
