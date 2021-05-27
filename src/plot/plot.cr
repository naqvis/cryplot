require "./baseplot"
require "./elems/axis_label"
require "./elems/histogram_style"
require "./elems/tics"

module Cryplot
  alias StringOrFloat = String | Float64

  # Class used to create a plot containing graphical elements
  class Plot < BasePlot
    # an object that permits histogram style to be customized.
    getter style_histogram : HistogramStyle
    # tics of the plot and return a reference to the corresponding specs object.
    getter tics : Tics

    # Return the specifications of the grid lines along major xtics on the bottom axis.
    getter xtics_major_bottom : MajorTics

    # Return the specifications of the grid lines along major xtics on the top axis.
    getter xtics_major_top : MajorTics

    # Return the specifications of the grid lines along minor xtics on the bottom axis.
    getter xtics_minor_bottom : MinorTics

    # Return the specifications of the grid lines along minor xtics on the top axis.
    getter xtics_minor_top : MinorTics

    # Return the specifications of the grid lines along major ytics on the left axis.
    getter ytics_major_left : MajorTics

    # Return the specifications of the grid lines along major ytics on the right axis.
    getter ytics_major_right : MajorTics

    # Return the specifications of the grid lines along minor ytics on the left axis.
    getter ytics_minor_left : MinorTics

    # Return the specifications of the grid lines along minor ytics on the right axis.
    getter ytics_minor_right : MinorTics

    # Return the specifications of the grid lines along major ztics.
    getter ztics_major : MajorTics

    # Return the specifications of the grid lines along minor ztics.
    getter ztics_minor : MinorTics

    # Return the specifications of the grid lines along minor rtics.
    getter rtics_major : MajorTics

    # Return the specifications of the grid lines along minor rtics.
    getter rtics_minor : MinorTics

    # The x-range of the plot as a gnuplot formatted string (e.g., "set xrange [0:1]")
    @xrange = ""
    # The y-range of the plot as a gnuplot formatted string (e.g., "set yrange [0:1]")
    @yrange = ""

    def initialize
      super

      # Show only major and minor xtics and ytics
      # Hide all other tics
      @style_histogram = HistogramStyle.new
      @tics = Tics.new
      @xtics_major_bottom = MajorTics.new("x").show
      @xtics_major_top = MajorTics.new("x2").hide
      @xtics_minor_bottom = MinorTics.new("x").show
      @xtics_minor_top = MinorTics.new("x2").hide
      @ytics_major_left = MajorTics.new("y").show
      @ytics_major_right = MajorTics.new("y2").hide
      @ytics_minor_left = MinorTics.new("y").show
      @ytics_minor_right = MinorTics.new("y2").hide
      @ztics_major = MajorTics.new("z").hide
      @ztics_minor = MinorTics.new("z").hide
      @rtics_major = MajorTics.new("r").hide
      @rtics_minor = MinorTics.new("r").hide
      @xlabel = AxisLabel.new("x")
      @ylabel = AxisLabel.new("y")
      @zlabel = AxisLabel.new("z")
      @rlabel = AxisLabel.new("r")
      @boxwidth = ""

      # Default options for fill style
      style_fill
        .solid
        .border_hide

      # Set all other default options
      box_width_relative(Consts::DEFAULT_FIGURE_BOXWIDTH_RELATIVE)

      # This is needed because of how drawHistogram works. Using `with histograms` don't work as well.
      gnuplot("set style data histogram")
    end

    # Set the label of the x-axis and return a reference to the corresponding specs object.
    def xlabel(label : String)
      @xlabel.text(label)
      @xlabel
    end

    # Set the label of the y-axis and return a reference to the corresponding specs object.
    def ylabel(label : String)
      @ylabel.text(label)
      @ylabel
    end

    # Set the x-range of the plot (also possible with empty values or autoscale options (e.g. "", "*")).
    def xrange(min : StringOrFloat, max : StringOrFloat)
      @xrange = "[#{min}:#{max}]"
    end

    # Set the y-range of the plot (also possible with empty values or autoscale options (e.g. "", "*")).
    def yrange(min : StringOrFloat, max : StringOrFloat)
      @yrange = "[#{min}:#{max}]"
    end

    # Set the default width of boxes in plots containing boxes (in absolute mode).
    # In absolute mode, a unit width is equivalent to one unit of length along the *x* axis.
    def box_width_absolute(val : Float64)
      @boxwidth = "#{val} absolute"
    end

    # Set the default width of boxes in plots containing boxes (in relative mode).
    # In relative mode, a unit width is equivalent to setting the boxes side by side.
    def box_width_relative(val : Float64)
      @boxwidth = "#{val} relative"
    end

    # Return the specifications of the grid lines along major xtics on the bottom axis.
    def xtics
      @xtics_major_bottom
    end

    # Return the specifications of the grid lines along major ytics on the left axis.
    def ytics
      @ytics_major_left
    end

    # Return the specifications of the grid lines along major ztics.
    def ztics
      @ztics_major
    end

    # Return the specifications of the grid lines along major rtics.
    def rtics
      @rtics_major
    end

    # Draw plot object with given style and given vectors (e.g., `plot.draw("lines", x, y)`).
    def draw_with_vecs(with_ : String, x : X, *vecs : Array) : Draw forall X
      use = ""
      @data += String.build do |sb|
        Gnuplot.writedataset(sb, @numdatasets, x, *vecs)

        # Set the using string to "" if X is not array of strings.
        # otherwise, x contain xtics strings. Set the `using` string
        # so that these are properly used as xtics
        if x.is_a?(Array(String))
          nvecs = vecs.size
          use = "0:" # here, column 0 means the pseudo column with numbers 0,1,2,3...
          2.upto(nvecs + 1) do |i|
            use += "#{i}:" # this constructs 0:2:3:4
          end
          use += "xtic(1)" # this terminates the string with 0:2:3:4:xtic(1), and thus column 1 is used for the xtics
        end
      end
      # Draw the data saved using a data set with index `@numdatasets`. Increase number of data sets and set the line style specification (desired behavior is 1, 2, 3 (incrementing as new lines are plotted)).
      val = draw("'#{@data_filename}' index #{@numdatasets}", use, with_).line_style(@drawspecs.size)
      @numdatasets += 1
      val
    end

    # Draw plot object with given style and given vectors (e.g., `plot.draw("lines", x, y)`) that may contain NaN values.
    def draw_with_vecs_containing_nan(with_ : String, x : X, *vecs : Array) : Draw forall X
      use = ""
      @data += String.build do |sb|
        Gnuplot.writedataset(sb, @numdatasets, x, *vecs)

        # Set the using string to "" if X is not array of strings.
        # otherwise, x contain xtics strings. Set the `using` string
        # so that these are properly used as xtics
        if x.is_a?(Array(String))
          nvecs = vecs.size
          use = "0:" # here, column 0 means the pseudo column with numbers 0,1,2,3...
          2.upto(nvecs + 1) do |i|
            use += "$(#{i}):" # this constructs 0:$(2):$(3):$(4)
          end
          use += "xtic(1)" # this terminates the string with 0:$(2):$(3):$(4):xtic(1), and thus column 1 is used for the xtics
        end
      end
      # Draw the data saved using a data set with index `@numdatasets`. Increase number of data sets and set the line style specification (desired behavior is 1, 2, 3 (incrementing as new lines are plotted)).
      val = draw("'#{@data_filename}' index #{@numdatasets}", use, with_).line_style(@drawspecs.size)
      @numdatasets += 1
      val
    end

    # Draw a curve with given @p x and @p y vectors.
    def draw_curve(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs("lines", x, y)
    end

    # Draw a curve with points with given @p x and @p y vectors.
    def draw_curve_with_points(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs("linespoints", x, y)
    end

    # Draw a curve with error bars along *x* with given @p x, @p y, and @p xdelta vectors.
    def draw_curve_with_error_bars_x(x : X, y : Y, xdelta : XD) : Draw forall X, Y, XD
      draw_with_vecs("xerrorlines", x, y, xdelta)
    end

    # Draw a curve with error bars along *x* with given @p x, @p y, @p xlow, and @p xhigh vectors.
    def draw_curve_with_error_bars_x(x : X, y : Y, xlow : XL, xhigh : XH) : Draw forall X, Y, XL, XH
      draw_with_vecs("xerrorlines", x, y, xlow, xhigh)
    end

    # Draw a curve with error bars along *y* with given @p x, @p y, and @p xdelta vectors.
    def draw_curve_with_error_bars_y(x : X, y : Y, ydelta : XD) : Draw forall X, Y, XD
      draw_with_vecs("yerrorlines", x, y, ydelta)
    end

    # Draw a curve with error bars along *y* with given @p x, @p y, @p xlow, and @p xhigh vectors.
    def draw_curve_with_error_bars_y(x : X, y : Y, ylow : YL, yhigh : YH) : Draw forall X, Y, YL, YH
      draw_with_vecs("yerrorlines", x, y, ylow, yhigh)
    end

    #  Draw a curve with error bars along *x* and *y* with given @p x, @p y, @p xdelta, and @p ydelta vectors.
    def draw_curve_with_error_bars_xy(x : X, y : Y, xdelta : XD, ydelta : YD) : Draw forall X, Y, XD, YD
      draw_with_vecs("xyerrorlines", x, y, xdelta, ydelta)
    end

    #  Draw a curve with error bars along *x* and *y* with given @p x, @p y, @p xlow, @p xhigh, @p ylow, and @p yhigh vectors.
    def draw_curve_with_error_bars_xy(x : X, y : Y, xlow : XL, xhigh : XH, ylow : YL, yhigh : YH) : Draw forall X, Y, XL, XH, YL, YH
      draw_with_vecs("xyerrorlines", x, y, xlow, xhigh, ylow, yhigh)
    end

    # Draw a curve with given @p x and @p y vectors, breaking this curve whenever NaN is found in @p x or @p y.
    def draw_broken_curve(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs_containing_nan("lines", x, y)
    end

    # Draw a curve with points with given @p x and @p y vectors, breaking this curve whenever NaN is found in @p x or @p y.
    def draw_broken_curve_with_points(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs_containing_nan("linespoints", x, y)
    end

    # Draw curves with given @p x and @p y vectors with filled areas above / below axes.
    def draw_curves_filled(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs("filledcurves", x, y)
    end

    # Draw curves with given @p x, @p y1 and @p y2 vectors with filled areas above / below / between curves.
    def draw_curves_filled(x : X, y1 : Y1, y2 : Y2) : Draw forall X, Y1, Y2
      draw_with_vecs("filledcurves", x, y1, y2)
    end

    #  Draw boxes with given @p x and @p y vectors.
    def draw_boxes(x : X, y : Y) : Draw forall X, Y
      draw_with_vecs("boxes", x, y)
    end

    # Draw boxes with given @p x and @p y vectors as well as the box widths @p xwidth.
    def draw_boxes(x : X, y : Y, xwidth : XW) : Draw forall X, Y, XW
      draw_with_vecs("boxes", x, y, xwidth)
    end

    # Draw boxes with error bars along *y* with given @p x, @p y, @p ydelta vectors.
    def draw_boxes_with_error_bars_y(x : X, y : Y, ydelta : YD) : Draw forall X, Y, YD
      draw_with_vecs("boxerrorbars", x, y, ydelta)
    end

    # Draw boxes with error bars along *y* with given @p x, @p y, @p ylow, and @p yhigh vectors.
    def draw_boxes_with_error_bars_y(x : X, y : Y, ylow : YL, yhigh : YH) : Draw forall X, Y, YL, YH
      draw_with_vecs("boxerrorbars", x, y, ylow, yhigh)
    end

    # Draw error bars along *x* with given @p x, @p y, and @p xdelta vectors.
    def draw_error_bars_x(x, y, xdelta)
      draw_with_vecs("xerrorbars", x, y, xdelta)
    end

    # Draw error bars along *x* with given @p x, @p y, @p xlow, and @p xhigh vectors.
    def draw_error_bars_x(x, y, xlow, xhigh)
      drawWithVecs("xerrorbars", x, y, xlow, xhigh)
    end

    # Draw error bars along *y* with given @p x, @p y, and @p ydelta vectors.
    def draw_error_bars_y(x, y, ydelta)
      draw_with_vecs("yerrorbars", x, y, ydelta)
    end

    # Draw error bars along *y* with given @p x, @p y, @p ylow, and @p yhigh vectors.
    def draw_error_bars_y(x, y, ylow, yhigh)
      draw_with_vecs("yerrorbars", x, y, ylow, yhigh)
    end

    # Draw error bars along *x* and *y* with given @p x, @p y, @p xdelta, and @p ydelta vectors.
    def draw_error_bars_xy(x, y, xdelta, ydelta)
      draw_with_vecs("xyerrorbars", x, y, xdelta, ydelta)
    end

    # Draw error bars along *x* and *y* with given @p x, @p y, @p xlow, @p xhigh, @p ylow, and @p yhigh vectors.
    def draw_error_bars_xy(x, y, xlow, xhigh, ylow, yhigh)
      draw_with_vecs("xyerrorbars", x, y, xlow, xhigh, ylow, yhigh)
    end

    # Draw steps with given @p x and @p y vectors. Identical to @ref drawStepsChangeFirstX.
    def draw_steps(x, y)
      draw_with_vecs_steps_change_first_x(x, y)
    end

    # Draw steps with given @p x and @p y vectors with steps along *x* changes first.
    def draw_steps_change_first_x(x, y)
      draw_with_vecs("steps", x, y)
    end

    # Draw steps with given @p x and @p y vectors with steps along *y* changes first.
    def draw_steps_change_first_y(x, y)
      draw_with_vecs("fsteps", x, y)
    end

    # Draw steps with given @p x and @p y vectors in a histogram style
    def draw_steps_histogram(x, y)
      draw_with_vecs("histeps", x, y)
    end

    # Draw steps with given @p x and @p y vectors with filled area below steps.
    def draw_steps_filled(x, y)
      draw_with_vecs("fillsteps", x, y)
    end

    # Draw dots with given @p x and @p y vectors.
    def draw_dots(x, y)
      draw_with_vecs("dots", x, y)
    end

    # Draw points with given @p x and @p y vectors.
    def draw_points(x, y)
      draw_with_vecs("points", x, y)
    end

    # Draw impulses with given @p x and @p y vectors.
    def draw_impulses(x, y)
      draw_with_vecs("impulses", x, y)
    end

    # Draw a histogram for the given @p y vector.
    def draw_histogram(y)
      drawWithVecs("", y) # empty string because we rely on `set style data histograms` since relying `with histograms` is not working very well (e.g., empty key/lenged appearing in columnstacked mode).
    end

    # Draw plot object with given style and given vectors (e.g., `plot.draw("lines", x, y)`).
    def draw_with_cols(name : String, with_ : String, cols : Array(String | Int32))
      cols = cols.map(&.to_s) if cols.first?.try &.is_a?(Int32)
      use = cols.join(":")
      what = "'#{name}'"
      draw(what, use, with_).line_style(@drawspecs.size)
    end

    # Draw a curve with given values at @p xcol and @p ycol columns in file @p name.
    def draw_curve(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "lines", [xcol, ycol])
    end

    # Draw a curve with points with given values at @p xcol and @p ycol columns in file @p name.
    def draw_curve_with_points(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "linespoints", [xcol, ycol])
    end

    # Draw a curve with error bars along *x* with given values at @p xcol, @p ycol, and @p xdeltacol columns in file @p name.
    def draw_curve_with_error_bars_x(name : String, xcol : String | Int32, ycol : String | Int32, xdeltacol : String | Int32)
      draw_with_cols(name, "xerrorlines", [xcol, ycol, xdeltacol])
    end

    # Draw a curve with error bars along *x* with given values at @p xcol, @p ycol, @p xlowcol, and @p xhighcol columns in file @p name.
    def draw_curve_with_error_bars_x(name : String, xcol : String | Int32, ycol : String | Int32, xlowcol : String | Int32, xhighcol : String | Int32)
      draw_with_cols(name, "xerrorlines", [xcol, ycol, xlowcol, xhighcol])
    end

    # Draw a curve with error bars along *y* with given values at @p xcol, @p ycol, and @p ydeltacol columns in file @p name.
    def draw_curve_with_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ydeltacol : String | Int32)
      draw_with_cols(name, "yerrorlines", [xcol, ycol, ydeltacol])
    end

    # Draw a curve with error bars along *y* with given values at @p xcol, @p ycol, @p ylowcol, and @p yhighcol columns in file @p name.
    def draw_curve_with_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ylowcol : String | Int32, yhighcol : String | Int32)
      draw_with_cols(name, "yerrorlines", [xcol, ycol, ylowcol, yhighcol])
    end

    # Draw a curve with error bars along *x* and *y* with given values at @p xcol, @p ycol, @p xdeltacol, and @p ydeltacol columns in file @p name.
    def draw_curve_with_error_bars_xy(name : String, xcol : String | Int32, ycol : String | Int32, xdeltacol : String | Int32, ydeltacol : String | Int32)
      draw_with_cols(name, "xyerrorlines", [xcol, ycol, xdeltacol, ydeltacol])
    end

    # Draw a curve with error bars along *x* and *y* with given values at @p xcol, @p ycol, @p xlowcol, @p xhighcol, @p ylowcol, and @p yhighcol columns in file @p name.
    def draw_curve_with_error_bars_xy(name : String, xcol : String | Int32, ycol : String | Int32, xlowcol : String | Int32, xhighcol : String | Int32, ylowcol : String | Int32, yhighcol : String | Int32)
      draw_with_cols(name, "xyerrorlines", [xcol, ycol, xlowcol, xhighcol, ylowcol, yhighcol])
    end

    # Draw boxes with given values at @p xcol and @p ycol columns in file @p name.
    def draw_boxes(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "boxes", [xcol, ycol])
    end

    # Draw boxes with given values at @p xcol and @p ycol columns in file @p name as well as the box widths @p xwidthcol.
    def draw_boxes(name : String, xcol : String | Int32, ycol : String | Int32, xwidthcol : String | Int32)
      draw_with_cols(name, "boxes", [xcol, ycol, xwidthcol])
    end

    # Draw boxes with error bars along *y* with given values at @p xcol, @p ycol, @p ydeltacol columns in file @p name.
    def draw_boxes_with_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ydeltacol : String | Int32)
      draw_with_cols(name, "boxerrorbars", [xcol, ycol, ydeltacol])
    end

    # Draw boxes with error bars along *y* with given values at @p xcol, @p ycol, @p ylowcol, and @p yhighcol columns in file @p name.
    def draw_boxes_with_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ylowcol : String | Int32, yhighcol : String | Int32)
      draw_with_cols(name, "boxerrorbars", [xcol, ycol, ylowcol, yhighcol])
    end

    # Draw error bars along *x* with given values at @p xcol, @p ycol, and @p xdeltacol columns in file @p name.
    def draw_error_bars_x(name : String, xcol : String | Int32, ycol : String | Int32, xdeltacol : String | Int32)
      draw_with_cols(name, "xerrorbars", [xcol, ycol, xdeltacol])
    end

    # Draw error bars along *x* with given values at @p xcol, @p ycol, @p xlowcol, and @p xhighcol columns in file @p name.
    def draw_error_bars_x(name : String, xcol : String | Int32, ycol : String | Int32, xlowcol : String | Int32, xhighcol : String | Int32)
      draw_with_cols(name, "xerrorbars", [xcol, ycol, xlowcol, xhighcol])
    end

    # Draw error bars along *y* with given values at @p xcol, @p ycol, and @p ydeltacol columns in file @p name.
    def draw_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ydeltacol : String | Int32)
      draw_with_cols(name, "yerrorbars", [xcol, ycol, ydeltacol])
    end

    # Draw error bars along *y* with given values at @p xcol, @p ycol, @p ylowcol, and @p yhighcol columns in file @p name.
    def draw_error_bars_y(name : String, xcol : String | Int32, ycol : String | Int32, ylowcol : String | Int32, yhighcol : String | Int32)
      draw_with_cols(name, "yerrorbars", [xcol, ycol, ylowcol, yhighcol])
    end

    # Draw error bars along *x* and *y* with given values at @p xcol, @p ycol, @p xdeltacol, and @p ydeltacol columns in file @p name.
    def draw_error_bars_xy(name : String, xcol : String | Int32, ycol : String | Int32, xdeltacol : String | Int32, ydeltacol : String | Int32)
      draw_with_cols(name, "xyerrorbars", [xcol, ycol, xdeltacol, ydeltacol])
    end

    # Draw error bars along *x* and *y* with given values at @p xcol, @p ycol, @p xlowcol, @p xhighcol, @p ylowcol, and @p yhighcol columns in file @p name.
    def draw_error_bars_xy(name : String, xcol : String | Int32, ycol : String | Int32, xlowcol : String | Int32, xhighcol : String | Int32, ylowcol : String | Int32, yhighcol : String | Int32)
      draw_with_cols(name, "xyerrorbars", [xcol, ycol, xlowcol, xhighcol, ylowcol, yhighcol])
    end

    # Draw steps with given values at @p xcol and @p ycol columns in file @p name. Identical to @ref drawStepsChangeFirstX.
    def draw_steps(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "steps", [xcol, ycol])
    end

    # Draw steps with given values at @p xcol and @p ycol columns in file @p name with steps along *x* changes first.
    def draw_steps_change_first_x(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "steps", [xcol, ycol])
    end

    # Draw steps with given values at @p xcol and @p ycol columns in file @p name with steps along *y* changes first.
    def draw_steps_change_first_y(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "fsteps", [xcol, ycol])
    end

    # Draw steps with given values at @p xcol and @p ycol columns in file @p name in a histogram style
    def draw_steps_histogram(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "histeps", [xcol, ycol])
    end

    # Draw steps with given values at @p xcol and @p ycol columns in file @p name with filled area below steps.
    def draw_steps_filled(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "fillsteps", [xcol, ycol])
    end

    # Draw dots with given values at @p xcol and @p ycol columns in file @p name.
    def draw_dots(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "dots", [xcol, ycol])
    end

    # Draw points with given values at @p xcol and @p ycol columns in file @p name.
    def draw_points(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "points", [xcol, ycol])
    end

    # Draw impulses with given values at @p xcol and @p ycol columns in file @p name.
    def draw_impulses(name : String, xcol : String | Int32, ycol : String | Int32)
      draw_with_cols(name, "impulses", [xcol, ycol])
    end

    # Draw a histogram with given values at @p ycol column in file @p name.
    def draw_histogram(name : String, ycol : String | Int32)
      draw_with_cols(name, "", [ycol])
    end

    def repr : String
      String.build do |script|
        # Add plot setup commands
        script << "#==============================================================================" << Gnuplot::NEW_LINE
        script << "# SETUP COMMANDS" << Gnuplot::NEW_LINE
        script << "#==============================================================================" << Gnuplot::NEW_LINE
        script << "set #{title.repr} #{Gnuplot::NEW_LINE}" unless title.repr.blank?
        script << Gnuplot.command_value_str("set xrange", @xrange)
        script << Gnuplot.command_value_str("set yrange", @yrange)
        script << @xlabel << Gnuplot::NEW_LINE
        script << @ylabel << Gnuplot::NEW_LINE
        script << @zlabel << Gnuplot::NEW_LINE
        script << @rlabel << Gnuplot::NEW_LINE
        script << @border << Gnuplot::NEW_LINE
        script << @grid << Gnuplot::NEW_LINE
        script << style_fill << Gnuplot::NEW_LINE
        script << @style_histogram << Gnuplot::NEW_LINE
        script << @tics << Gnuplot::NEW_LINE
        script << @xtics_major_bottom << Gnuplot::NEW_LINE
        script << @xtics_major_top << Gnuplot::NEW_LINE
        script << @xtics_minor_bottom << Gnuplot::NEW_LINE
        script << @xtics_minor_top << Gnuplot::NEW_LINE
        script << @ytics_major_left << Gnuplot::NEW_LINE
        script << @ytics_major_right << Gnuplot::NEW_LINE
        script << @ytics_minor_left << Gnuplot::NEW_LINE
        script << @ytics_minor_right << Gnuplot::NEW_LINE
        script << @ztics_major << Gnuplot::NEW_LINE
        script << @ztics_minor << Gnuplot::NEW_LINE
        script << @rtics_major << Gnuplot::NEW_LINE
        script << @rtics_minor << Gnuplot::NEW_LINE
        script << @legend << Gnuplot::NEW_LINE
        script << Gnuplot.command_value_str("set boxwidth", @boxwidth)
        script << Gnuplot.command_value_str("set samples", @samples)
        script << Gnuplot.command_value_str("set datafile missing", MISSING_INDICATOR)
        # Add custom gnuplot commands
        unless @customcmds.empty?
          script << "#==============================================================================" << Gnuplot::NEW_LINE
          script << "# CUSTOM EXPLICIT GNUPLOT COMMANDS" << Gnuplot::NEW_LINE
          script << "#==============================================================================" << Gnuplot::NEW_LINE
          @customcmds.each do |c|
            script << c << Gnuplot::NEW_LINE
          end
        end

        # Add the actual plot commands for all draw_xyz() calls
        script << "#==============================================================================" << Gnuplot::NEW_LINE
        script << "# PLOT COMMANDS" << Gnuplot::NEW_LINE
        script << "#==============================================================================" << Gnuplot::NEW_LINE
        script << "plot \\\n" # use `\` to have a plot command in each individual line!

        # write plot commands and style per plot
        n = @drawspecs.size
        0.upto(n - 1) do |i|
          script << "    " << @drawspecs[i].repr << (i < n - 1 ? ", \\\n" : "") # consider indentation with 4 spaces!
        end

        # Add an empty line at the end
        script << Gnuplot::NEW_LINE
      end
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
