require "./line"
require "./point"
require "./fill"
require "./fill_curve"
require "../consts"

module Cryplot
  # class where options for the plotted elements can be specified
  class Draw
    include LineMixin(Draw)
    include PointMixin(Draw)
    include FillMixin(Draw)
    include FilledCurveMixin(Draw)

    # The string representing `what` to be plot (e.g., "'filename'", "sin(x)").
    @what : String
    # The string representing the `using` expression (e.g., "using 1:2", "using 4:6:8:9").
    @using : String
    # The string representing the `with plotstyle` expression (e.g., "lines", "linespoints", "dots").
    @with : String
    # The title of the plot as a gnuplot formatted string (e.g., "title 'sin(x)'").
    @title : String = ""
    # The column in the data file containing the x tic labels.
    @xtic : String = ""
    # The column in the data file containing the y tic labels.
    @ytic : String = ""

    def initialize(@what, @using, @with)
      line_width(Consts::DEFAULT_LINEWIDTH)
    end

    # Set the legend label of the plotted element.
    def label(text : String)
      @title = "title '#{text}'"
      self
    end

    # Set the legend label of the plotted element to be retrieved from the header of column.
    def label_from_column_header
      @title = "title columnheader"
      self
    end

    # Set the legend label of the plotted element to be retrieved from the header of a column with given index.
    def label_from_column_header(index : Int32)
      @title = "title columnheader(#{index})"
      self
    end

    # et the legend label of the plotted element to be ignored.
    def label_none
      @title = "notitle"
      self
    end

    # Set the legend label to be determined defmatically from the plot expression
    def label_default
      @title = ""
      self
    end

    # Set the column in the data file containing the tic labels for *x* axis
    def xtics(icol : Int32 | String)
      icol = "'#{icol}'" if icol.is_a?(String)
      @xtic = "xtic(stringcolumn(#{icol}))"
      self
    end

    # Set the column in the data file containing the tic labels for *y* axis
    def ytics(icol : Int32 | String)
      icol = "'#{icol}'" if icol.is_a?(String)
      @ytic = "ytic(stringcolumn(#{icol}))"
      self
    end

    def repr : String
      u = @using
      u += ":#{@xtic}" unless @xtic.blank?
      u += ":#{@ytic}" unless @ytic.blank?
      String.build do |sb|
        sb << @what << " "
        sb << "using #{u} " unless u.blank?
        sb << @title << " "
        sb << "with #{@with} " unless @with.blank?
        sb << filled_curve_repr << " "
        sb << line_repr << " "
        sb << point_repr << " "
        sb << fill_repr << " "
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
