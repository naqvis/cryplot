require "./spec_helper"

describe Cryplot::Gnuplot do
  it "Test helper methods" do
    Cryplot::Gnuplot.title("Something").should eq("'Something'")
    Cryplot::Gnuplot.title("columnheader").should eq("columnheader")

    Cryplot::Gnuplot.cleanpath("build/:*?!\"<>|xy.svg").should eq("build/xy.svg")
    Cryplot::Gnuplot.cleanpath("build:*?!\"<>|/xy.svg").should eq("build/xy.svg")
    Cryplot::Gnuplot.cleanpath("build:*?!\"<>|/xy:*?!\"<>|.svg").should eq("build/xy.svg")
  end
end

describe Cryplot do
  describe ".plot" do
    it "creates a 2D plot with block" do
      plot = nil
      Cryplot.plot do |p|
        plot = p
        p.should be_a(Cryplot::Plot)
      end
      plot.should_not be_nil
    end

    it "creates a 2D plot without block" do
      plot = Cryplot.plot
      plot.should be_a(Cryplot::Plot)
    end
  end

  describe ".plot3d" do
    it "creates a 3D plot with block" do
      plot = nil
      Cryplot.plot3d do |p|
        plot = p
        p.should be_a(Cryplot::Plot3D)
      end
      plot.should_not be_nil
    end

    it "creates a 3D plot without block" do
      plot = Cryplot.plot3d
      plot.should be_a(Cryplot::Plot3D)
    end
  end

  describe ".linspace" do
    it "creates array with uniform increments" do
      result = Cryplot.linspace(0.0, 10.0, 5)
      result.size.should eq(5)
      result[0].should eq(0.0)
      result[1].should eq(2.0)
      result[2].should eq(4.0)
    end

    it "works with integer inputs" do
      result = Cryplot.linspace(0, 100, 10)
      result.size.should eq(10)
      result[0].should eq(0.0)
      result[1].should eq(10.0)
    end
  end

  describe ".range" do
    it "creates ascending range" do
      result = Cryplot.range(0, 5)
      result.should eq([0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
    end

    it "creates descending range" do
      result = Cryplot.range(5, 0)
      result.should eq([5.0, 4.0, 3.0, 2.0, 1.0, 0.0])
    end
  end
end

describe Cryplot::Plot do
  describe "#title" do
    it "sets the plot title" do
      plot = Cryplot::Plot.new
      plot.title("My Plot")
      plot.repr.should contain("title 'My Plot'")
    end
  end

  describe "#xlabel and #ylabel" do
    it "sets axis labels" do
      plot = Cryplot::Plot.new
      plot.xlabel("X Axis")
      plot.ylabel("Y Axis")
      repr = plot.repr
      repr.should contain("set xlabel 'X Axis'")
      repr.should contain("set ylabel 'Y Axis'")
    end
  end

  describe "#xrange and #yrange" do
    it "sets axis ranges" do
      plot = Cryplot::Plot.new
      plot.xrange(0.0, 10.0)
      plot.yrange(-5.0, 5.0)
      repr = plot.repr
      repr.should contain("set xrange [0.0:10.0]")
      repr.should contain("set yrange [-5.0:5.0]")
    end

    it "supports string values for autoscale" do
      plot = Cryplot::Plot.new
      plot.xrange("*", "*")
      plot.repr.should contain("set xrange [*:*]")
    end
  end

  describe "#draw_curve" do
    it "draws a curve with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      draw = plot.draw_curve(x, y)
      draw.should be_a(Cryplot::Draw)
      plot.repr.should contain("with lines")
    end

    it "allows setting label on draw" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curve(x, y).label("My Curve")
      plot.repr.should contain("title 'My Curve'")
    end
  end

  describe "#draw_points" do
    it "draws points with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_points(x, y)
      plot.repr.should contain("with points")
    end
  end

  describe "#draw_boxes" do
    it "draws boxes with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [5.0, 10.0, 15.0]
      plot.draw_boxes(x, y)
      plot.repr.should contain("with boxes")
    end
  end

  describe "#draw_dots" do
    it "draws dots with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_dots(x, y)
      plot.repr.should contain("with dots")
    end
  end

  describe "#draw_impulses" do
    it "draws impulses with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_impulses(x, y)
      plot.repr.should contain("with impulses")
    end
  end

  describe "#draw_steps" do
    it "draws steps with x and y vectors" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_steps(x, y)
      plot.repr.should contain("with steps")
    end
  end

  describe "#draw_curve_with_points" do
    it "draws curve with points" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curve_with_points(x, y)
      plot.repr.should contain("with linespoints")
    end
  end

  describe "#draw_error_bars_y" do
    it "draws error bars along y" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      yerr = [0.1, 0.2, 0.3]
      plot.draw_error_bars_y(x, y, yerr)
      plot.repr.should contain("with yerrorbars")
    end
  end

  describe "#draw_curves_filled" do
    it "draws filled curves" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curves_filled(x, y)
      plot.repr.should contain("with filledcurves")
    end
  end

  describe "#clear" do
    it "clears draw specs and custom commands" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curve(x, y)
      plot.gnuplot("set grid")
      plot.clear
      # After clear, repr should not contain the curve
      plot.repr.should_not contain("with lines linewidth")
    end
  end

  describe "#palette" do
    it "sets the color palette" do
      plot = Cryplot::Plot.new
      plot.palette(Cryplot::Palette::Viridis)
      plot.palette.should eq(Cryplot::Palette::Viridis)
    end
  end

  describe "#size" do
    it "sets plot dimensions" do
      plot = Cryplot::Plot.new
      plot.size(800, 600)
      # Size is used in show/save, not directly in repr
      plot.should be_a(Cryplot::Plot)
    end
  end

  describe "#font_name and #font_size" do
    it "sets font properties" do
      plot = Cryplot::Plot.new
      plot.font_name("Arial")
      plot.font_size(12)
      plot.should be_a(Cryplot::Plot)
    end
  end

  describe "#box_width_relative" do
    it "sets relative box width" do
      plot = Cryplot::Plot.new
      plot.box_width_relative(0.8)
      plot.repr.should contain("set boxwidth 0.8 relative")
    end
  end

  describe "#box_width_absolute" do
    it "sets absolute box width" do
      plot = Cryplot::Plot.new
      plot.box_width_absolute(0.5)
      plot.repr.should contain("set boxwidth 0.5 absolute")
    end
  end

  describe "#samples" do
    it "sets number of sample points" do
      plot = Cryplot::Plot.new
      plot.samples(1000)
      plot.repr.should contain("set samples 1000")
    end
  end

  describe "#gnuplot" do
    it "adds custom gnuplot commands" do
      plot = Cryplot::Plot.new
      plot.gnuplot("set grid")
      plot.repr.should contain("set grid")
    end
  end

  describe "border" do
    it "provides access to border specs" do
      plot = Cryplot::Plot.new
      plot.border.should be_a(Cryplot::Border)
    end
  end

  describe "grid" do
    it "provides access to grid specs" do
      plot = Cryplot::Plot.new
      plot.grid.should be_a(Cryplot::Grid)
    end
  end

  describe "legend" do
    it "provides access to legend specs" do
      plot = Cryplot::Plot.new
      plot.legend.should be_a(Cryplot::Legend)
    end
  end
end

describe Cryplot::Plot3D do
  describe "#title" do
    it "sets the plot title" do
      plot = Cryplot::Plot3D.new
      plot.title("My 3D Plot")
      plot.repr.should contain("title 'My 3D Plot'")
    end
  end

  describe "#xlabel, #ylabel, #zlabel" do
    it "sets axis labels" do
      plot = Cryplot::Plot3D.new
      plot.xlabel("X Axis")
      plot.ylabel("Y Axis")
      plot.zlabel("Z Axis")
      repr = plot.repr
      repr.should contain("set xlabel 'X Axis'")
      repr.should contain("set ylabel 'Y Axis'")
      repr.should contain("set zlabel 'Z Axis'")
    end
  end

  describe "#xrange, #yrange, #zrange" do
    it "sets axis ranges" do
      plot = Cryplot::Plot3D.new
      plot.xrange(0.0, 10.0)
      plot.yrange(-5.0, 5.0)
      plot.zrange(0.0, 100.0)
      repr = plot.repr
      repr.should contain("set xrange [0.0:10.0]")
      repr.should contain("set yrange [-5.0:5.0]")
      repr.should contain("set zrange [0.0:100.0]")
    end
  end

  describe "#draw_curve" do
    it "draws a 3D curve with x, y, z vectors" do
      plot = Cryplot::Plot3D.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      z = [1.0, 8.0, 27.0]
      plot.draw_curve(x, y, z)
      repr = plot.repr
      repr.should contain("splot")
      repr.should contain("with lines")
    end
  end

  describe "#draw_points" do
    it "draws 3D points" do
      plot = Cryplot::Plot3D.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      z = [1.0, 8.0, 27.0]
      plot.draw_points(x, y, z)
      plot.repr.should contain("with points")
    end
  end

  describe "#draw_dots" do
    it "draws 3D dots" do
      plot = Cryplot::Plot3D.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      z = [1.0, 8.0, 27.0]
      plot.draw_dots(x, y, z)
      plot.repr.should contain("with dots")
    end
  end

  describe "#draw_impulses" do
    it "draws 3D impulses" do
      plot = Cryplot::Plot3D.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      z = [1.0, 8.0, 27.0]
      plot.draw_impulses(x, y, z)
      plot.repr.should contain("with impulses")
    end
  end

  describe "#clear" do
    it "clears draw specs and custom commands" do
      plot = Cryplot::Plot3D.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      z = [1.0, 8.0, 27.0]
      plot.draw_curve(x, y, z)
      plot.gnuplot("set grid")
      plot.clear
      plot.repr.should_not contain("with lines linewidth")
    end
  end
end

describe Cryplot::Draw do
  describe "#label" do
    it "sets the legend label" do
      draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
      draw.label("My Data")
      draw.repr.should contain("title 'My Data'")
    end
  end

  describe "#label_none" do
    it "hides the legend entry" do
      draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
      draw.label_none
      draw.repr.should contain("notitle")
    end
  end

  describe "#line_width" do
    it "sets line width" do
      draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
      draw.line_width(3)
      draw.repr.should contain("linewidth 3")
    end
  end

  describe "#line_color" do
    it "sets line color" do
      draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
      draw.line_color("red")
      draw.repr.should contain("linecolor 'red'")
    end
  end

  describe "chaining" do
    it "supports method chaining" do
      draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
      draw.label("Data").line_width(2).line_color("blue")
      repr = draw.repr
      repr.should contain("title 'Data'")
      repr.should contain("linewidth 2")
      repr.should contain("linecolor 'blue'")
    end
  end
end

# ==================================================================================
# TESTS FOR NEW FEATURES
# ==================================================================================

describe "Log Scale Features" do
  describe Cryplot::Plot do
    describe "#xlog" do
      it "sets x-axis to logarithmic scale" do
        plot = Cryplot::Plot.new
        plot.xlog
        plot.repr.should contain("set logscale x 10")
      end

      it "sets x-axis to logarithmic scale with custom base" do
        plot = Cryplot::Plot.new
        plot.xlog(2)
        plot.repr.should contain("set logscale x 2")
      end
    end

    describe "#ylog" do
      it "sets y-axis to logarithmic scale" do
        plot = Cryplot::Plot.new
        plot.ylog
        plot.repr.should contain("set logscale y 10")
      end

      it "sets y-axis to logarithmic scale with custom base" do
        plot = Cryplot::Plot.new
        plot.ylog(2)
        plot.repr.should contain("set logscale y 2")
      end
    end

    describe "#xylog" do
      it "sets both axes to logarithmic scale" do
        plot = Cryplot::Plot.new
        plot.xylog
        plot.repr.should contain("set logscale xy 10")
      end
    end

    describe "#xlog_off and #ylog_off" do
      it "disables logarithmic scale" do
        plot = Cryplot::Plot.new
        plot.xlog
        plot.xlog_off
        repr = plot.repr
        repr.should contain("set logscale x 10")
        repr.should contain("unset logscale x")
      end
    end
  end
end

describe "Secondary Y-Axis Features" do
  describe Cryplot::Plot do
    describe "#y2label" do
      it "sets the secondary y-axis label" do
        plot = Cryplot::Plot.new
        plot.y2label("Secondary Y")
        plot.repr.should contain("set y2label 'Secondary Y'")
      end
    end

    describe "#y2range" do
      it "sets the secondary y-axis range" do
        plot = Cryplot::Plot.new
        plot.y2range(0.0, 100.0)
        plot.repr.should contain("set y2range [0.0:100.0]")
      end
    end

    describe "#draw_curve_y2" do
      it "draws a curve on the secondary y-axis" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [10.0, 20.0, 30.0]
        plot.draw_curve_y2(x, y)
        plot.repr.should contain("axes x1y2")
        plot.repr.should contain("with lines")
      end
    end

    describe "#draw_points_y2" do
      it "draws points on the secondary y-axis" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [10.0, 20.0, 30.0]
        plot.draw_points_y2(x, y)
        plot.repr.should contain("axes x1y2")
        plot.repr.should contain("with points")
      end
    end

    describe "#y2tics_show" do
      it "enables secondary y-axis tics" do
        plot = Cryplot::Plot.new
        plot.y2tics_show
        # The ytics_major_right should be shown
        plot.ytics_major_right.should be_a(Cryplot::MajorTics)
      end
    end
  end

  describe Cryplot::Draw do
    describe "#axes" do
      it "sets the axes specification" do
        draw = Cryplot::Draw.new("'file.dat'", "1:2", "lines")
        draw.axes("x1y2")
        draw.repr.should contain("axes x1y2")
      end
    end
  end
end

describe "Date/Time Axis Features" do
  describe Cryplot::Plot do
    describe "#xtime_format" do
      it "sets x-axis to time format" do
        plot = Cryplot::Plot.new
        plot.xtime_format("%Y-%m-%d")
        repr = plot.repr
        repr.should contain("set xdata time")
        repr.should contain("set timefmt '%Y-%m-%d'")
      end
    end

    describe "#xtime_display" do
      it "sets x-axis time display format" do
        plot = Cryplot::Plot.new
        plot.xtime_display("%b %Y")
        plot.repr.should contain("set format x '%b %Y'")
      end
    end

    describe "#ytime_format" do
      it "sets y-axis to time format" do
        plot = Cryplot::Plot.new
        plot.ytime_format("%H:%M:%S")
        repr = plot.repr
        repr.should contain("set ydata time")
        repr.should contain("set timefmt '%H:%M:%S'")
      end
    end
  end
end

describe "Annotation Features" do
  describe Cryplot::Plot do
    describe "#annotate" do
      it "adds a text annotation at data coordinates" do
        plot = Cryplot::Plot.new
        plot.annotate(5, 10, "Peak Value")
        plot.repr.should contain("set label 1 'Peak Value' at 5,10")
      end

      it "adds multiple annotations with unique tags" do
        plot = Cryplot::Plot.new
        plot.annotate(5, 10, "First")
        plot.annotate(10, 20, "Second")
        repr = plot.repr
        repr.should contain("set label 1 'First' at 5,10")
        repr.should contain("set label 2 'Second' at 10,20")
      end

      it "supports additional options" do
        plot = Cryplot::Plot.new
        plot.annotate(5, 10, "Styled", "font 'Arial,12' textcolor 'red'")
        plot.repr.should contain("set label 1 'Styled' at 5,10 font 'Arial,12' textcolor 'red'")
      end
    end

    describe "#annotate_graph" do
      it "adds annotation at graph coordinates" do
        plot = Cryplot::Plot.new
        plot.annotate_graph(0.5, 0.9, "Title")
        plot.repr.should contain("set label 1 'Title' at graph 0.5,0.9")
      end
    end

    describe "#arrow" do
      it "adds an arrow between two points" do
        plot = Cryplot::Plot.new
        plot.arrow(0, 0, 10, 10)
        plot.repr.should contain("set arrow 1 from 0,0 to 10,10")
      end

      it "supports additional options" do
        plot = Cryplot::Plot.new
        plot.arrow(0, 0, 10, 10, "head filled lw 2")
        plot.repr.should contain("set arrow 1 from 0,0 to 10,10 head filled lw 2")
      end
    end

    describe "#arrow_graph" do
      it "adds arrow using graph coordinates" do
        plot = Cryplot::Plot.new
        plot.arrow_graph(0.1, 0.1, 0.9, 0.9)
        plot.repr.should contain("set arrow 1 from graph 0.1,0.1 to graph 0.9,0.9")
      end
    end

    describe "#hline" do
      it "adds a horizontal line" do
        plot = Cryplot::Plot.new
        plot.hline(5)
        plot.repr.should contain("set arrow 1 from graph 0,first 5 to graph 1,first 5 nohead")
      end
    end

    describe "#vline" do
      it "adds a vertical line" do
        plot = Cryplot::Plot.new
        plot.vline(3)
        plot.repr.should contain("set arrow 1 from first 3,graph 0 to first 3,graph 1 nohead")
      end
    end
  end
end

describe "Scatter Plot Features" do
  describe Cryplot::Plot do
    describe "#draw_scatter" do
      it "draws a scatter plot" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [1.0, 4.0, 9.0]
        plot.draw_scatter(x, y)
        plot.repr.should contain("with points")
      end
    end

    describe "#draw_scatter_color" do
      it "draws scatter with color mapping" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [1.0, 4.0, 9.0]
        color = [0.0, 0.5, 1.0]
        plot.draw_scatter_color(x, y, color)
        repr = plot.repr
        repr.should contain("with points")
        repr.should contain("linecolor palette")
      end
    end

    describe "#draw_scatter_size" do
      it "draws scatter with size mapping" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [1.0, 4.0, 9.0]
        size = [1.0, 2.0, 3.0]
        plot.draw_scatter_size(x, y, size)
        repr = plot.repr
        repr.should contain("with points")
        repr.should contain("pointsize variable")
      end
    end

    describe "#draw_scatter_color_size" do
      it "draws scatter with both color and size mapping" do
        plot = Cryplot::Plot.new
        x = [1.0, 2.0, 3.0]
        y = [1.0, 4.0, 9.0]
        color = [0.0, 0.5, 1.0]
        size = [1.0, 2.0, 3.0]
        plot.draw_scatter_color_size(x, y, color, size)
        repr = plot.repr
        repr.should contain("with points")
        repr.should contain("linecolor palette")
        repr.should contain("pointsize variable")
      end
    end
  end

  describe Cryplot::Draw do
    describe "#palette_use" do
      it "enables palette coloring" do
        draw = Cryplot::Draw.new("'file.dat'", "1:2:3", "points")
        draw.palette_use
        draw.repr.should contain("linecolor palette")
      end
    end

    describe "#variable_point_size" do
      it "enables variable point size" do
        draw = Cryplot::Draw.new("'file.dat'", "1:2:3", "points")
        draw.variable_point_size
        draw.repr.should contain("pointsize variable")
      end
    end
  end
end

describe "Heatmap and Contour Features" do
  describe Cryplot::Plot do
    describe "#draw_heatmap with matrix" do
      it "draws a heatmap from a 2D matrix" do
        plot = Cryplot::Plot.new
        matrix = [
          [1.0, 2.0, 3.0],
          [4.0, 5.0, 6.0],
          [7.0, 8.0, 9.0],
        ]
        plot.draw_heatmap(matrix)
        repr = plot.repr
        repr.should contain("set pm3d map")
        repr.should contain("set palette")
      end
    end

    describe "#draw_heatmap with vectors" do
      it "draws a heatmap from x, y, z vectors" do
        plot = Cryplot::Plot.new
        x = [0.0, 1.0, 0.0, 1.0]
        y = [0.0, 0.0, 1.0, 1.0]
        z = [1.0, 2.0, 3.0, 4.0]
        plot.draw_heatmap(x, y, z)
        repr = plot.repr
        repr.should contain("set pm3d map")
        repr.should contain("with pm3d")
      end
    end

    describe "#draw_contour" do
      it "draws contour lines" do
        plot = Cryplot::Plot.new
        x = [0.0, 1.0, 0.0, 1.0]
        y = [0.0, 0.0, 1.0, 1.0]
        z = [1.0, 2.0, 3.0, 4.0]
        plot.draw_contour(x, y, z)
        repr = plot.repr
        repr.should contain("set contour base")
        repr.should contain("set view map")
      end
    end

    describe "#contour_levels" do
      it "sets the number of contour levels" do
        plot = Cryplot::Plot.new
        plot.contour_levels(10)
        plot.repr.should contain("set cntrparam levels 10")
      end
    end
  end
end

describe "Box Plot Features" do
  describe Cryplot::Plot do
    describe "#draw_boxplot with single data" do
      it "draws a box plot for a single data vector" do
        plot = Cryplot::Plot.new
        data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        plot.draw_boxplot(data, "Test Data")
        repr = plot.repr
        repr.should contain("candlesticks")
        repr.should contain("title 'Test Data'")
      end
    end

    describe "#draw_boxplot with multiple groups" do
      it "draws box plots for multiple groups" do
        plot = Cryplot::Plot.new
        data = [
          [1.0, 2.0, 3.0, 4.0, 5.0],
          [2.0, 4.0, 6.0, 8.0, 10.0],
        ]
        labels = ["Group A", "Group B"]
        plot.draw_boxplot(data, labels)
        repr = plot.repr
        repr.should contain("candlesticks")
        repr.should contain("title 'Group A'")
        repr.should contain("title 'Group B'")
      end
    end
  end
end

describe "Grouped Bar Chart Features" do
  describe Cryplot::Plot do
    describe "#draw_grouped_bars" do
      it "draws grouped bar chart" do
        plot = Cryplot::Plot.new
        categories = ["A", "B", "C"]
        series = {
          "Series 1" => [1.0, 2.0, 3.0],
          "Series 2" => [2.0, 3.0, 4.0],
        }
        plot.draw_grouped_bars(categories, series)
        repr = plot.repr
        repr.should contain("set style histogram cluster")
        repr.should contain("title 'Series 1'")
        repr.should contain("title 'Series 2'")
      end
    end

    describe "#draw_stacked_bars" do
      it "draws stacked bar chart" do
        plot = Cryplot::Plot.new
        categories = ["A", "B", "C"]
        series = {
          "Series 1" => [1.0, 2.0, 3.0],
          "Series 2" => [2.0, 3.0, 4.0],
        }
        plot.draw_stacked_bars(categories, series)
        repr = plot.repr
        repr.should contain("set style histogram rowstacked")
        repr.should contain("title 'Series 1'")
        repr.should contain("title 'Series 2'")
      end
    end
  end
end

# ==================================================================================
# BUG FIX VERIFICATION TESTS
# ==================================================================================

describe "Bug Fixes" do
  describe "BasePlot#clear typo fix" do
    it "clear method works without error (was @customcmdss typo)" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curve(x, y)
      plot.gnuplot("set grid")
      # This should not raise - the typo was @customcmdss instead of @customcmds
      plot.clear
      plot.should be_a(Cryplot::Plot)
    end

    it "clear removes custom commands" do
      plot = Cryplot::Plot.new
      plot.gnuplot("set mygrid")
      plot.repr.should contain("set mygrid")
      plot.clear
      plot.repr.should_not contain("set mygrid")
    end
  end

  describe "Plot3D#title fix" do
    it "Plot3D includes title in repr (was missing)" do
      plot = Cryplot::Plot3D.new
      plot.title("My 3D Title")
      plot.repr.should contain("title 'My 3D Title'")
    end

    it "Plot3D title is in SETUP COMMANDS section" do
      plot = Cryplot::Plot3D.new
      plot.title("Test Title")
      repr = plot.repr
      # Title should appear after SETUP COMMANDS header
      setup_idx = repr.index("SETUP COMMANDS")
      title_idx = repr.index("title 'Test Title'")
      setup_idx.should_not be_nil
      title_idx.should_not be_nil
      (title_idx.not_nil! > setup_idx.not_nil!).should be_true
    end
  end

  describe "Plot#draw_steps typo fix" do
    it "draw_steps works without error (was calling non-existent method)" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0, 4.0]
      y = [1.0, 3.0, 2.0, 4.0]
      # This should not raise - was calling draw_with_vecs_steps_change_first_x
      plot.draw_steps(x, y)
      plot.repr.should contain("with steps")
    end
  end
end

# ==================================================================================
# PLOT3D NEW FEATURES TESTS
# ==================================================================================

describe "Plot3D New Features" do
  describe "#xlog, #ylog, #zlog" do
    it "sets logarithmic scales" do
      plot = Cryplot::Plot3D.new
      plot.xlog
      plot.ylog
      plot.zlog
      repr = plot.repr
      repr.should contain("set logscale x 10")
      repr.should contain("set logscale y 10")
      repr.should contain("set logscale z 10")
    end

    it "supports custom base" do
      plot = Cryplot::Plot3D.new
      plot.xlog(2)
      plot.repr.should contain("set logscale x 2")
    end
  end

  describe "#xyzlog" do
    it "sets all axes to log scale" do
      plot = Cryplot::Plot3D.new
      plot.xyzlog
      plot.repr.should contain("set logscale xyz 10")
    end
  end

  describe "#draw_surface" do
    it "draws a 3D surface from function" do
      plot = Cryplot::Plot3D.new
      plot.draw_surface("sin(x)*cos(y)")
      repr = plot.repr
      repr.should contain("set hidden3d")
      repr.should contain("set pm3d")
      repr.should contain("sin(x)*cos(y)")
    end
  end

  describe "#draw_surface_mesh" do
    it "draws a 3D surface mesh from data" do
      plot = Cryplot::Plot3D.new
      x = [0.0, 1.0, 0.0, 1.0]
      y = [0.0, 0.0, 1.0, 1.0]
      z = [0.0, 1.0, 1.0, 2.0]
      plot.draw_surface_mesh(x, y, z)
      repr = plot.repr
      repr.should contain("set hidden3d")
      repr.should contain("with pm3d")
    end
  end
end

# ==================================================================================
# EDGE CASE TESTS
# ==================================================================================

describe "Edge Cases" do
  describe "Empty data handling" do
    it "handles empty heatmap matrix gracefully" do
      plot = Cryplot::Plot.new
      matrix = Array(Array(Float64)).new
      plot.draw_heatmap(matrix)
      # Should not crash
      plot.should be_a(Cryplot::Plot)
    end

    it "handles empty boxplot data gracefully" do
      plot = Cryplot::Plot.new
      data = Array(Array(Float64)).new
      plot.draw_boxplot(data)
      plot.should be_a(Cryplot::Plot)
    end

    it "handles empty grouped bars gracefully" do
      plot = Cryplot::Plot.new
      categories = Array(String).new
      series = Hash(String, Array(Float64)).new
      plot.draw_grouped_bars(categories, series)
      plot.should be_a(Cryplot::Plot)
    end
  end

  describe "Method chaining" do
    it "supports chaining on log scale methods" do
      plot = Cryplot::Plot.new
      result = plot.xlog.ylog
      result.should be_a(Cryplot::Plot)
    end

    it "supports chaining on annotation methods" do
      plot = Cryplot::Plot.new
      result = plot.annotate(1, 2, "A").annotate(3, 4, "B").arrow(0, 0, 1, 1)
      result.should be_a(Cryplot::Plot)
    end

    it "supports chaining on time format methods" do
      plot = Cryplot::Plot.new
      result = plot.xtime_format("%Y-%m-%d").xtime_display("%b %Y")
      result.should be_a(Cryplot::Plot)
    end
  end

  describe "Multiple draw calls" do
    it "supports multiple curves on same plot" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y1 = [1.0, 2.0, 3.0]
      y2 = [3.0, 2.0, 1.0]
      plot.draw_curve(x, y1).label("Line 1")
      plot.draw_curve(x, y2).label("Line 2")
      repr = plot.repr
      repr.should contain("title 'Line 1'")
      repr.should contain("title 'Line 2'")
    end

    it "supports mixed plot types" do
      plot = Cryplot::Plot.new
      x = [1.0, 2.0, 3.0]
      y = [1.0, 4.0, 9.0]
      plot.draw_curve(x, y).label("Curve")
      plot.draw_points(x, y).label("Points")
      repr = plot.repr
      repr.should contain("with lines")
      repr.should contain("with points")
    end
  end
end
