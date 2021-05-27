require "./consts"
require "./palettes"
require "./gnuplot"
require "./elems/border"
require "./elems/draw"
require "./elems/font"
require "./elems/grid"
require "./elems/fillstyle"
require "./elems/legend"
require "./elems/title"

module Cryplot
  # Class used to create a plot containing graphical elements
  abstract class BasePlot
    # gnu palette to be used
    property palette : Cryplot::Palette = Consts::DEFAULT_PALETTE
    # Toggle automatic cleaning of temporary files (enabled by default)
    property autoclean : Bool = true
    # font name and siz in the plot
    @font : Font
    # border style of the plot
    getter border : Border
    # The vector of grid specs for the major and minor grid lines in the plot (for xtics, ytics, mxtics, etc.).
    getter grid : Grid
    # The specs for the fill style of the plot elements in the plot that can be painted.
    getter style_fill : FillStyle
    # legend specs of the plot
    getter legend : Legend
    # title of the plot
    getter title : Title
    # The number of sample points for functions
    @samples : String = ""
    # The plot specs for each call to gnuplot plot function
    @drawspecs : Array(Draw)
    # The strings containing gnuplot custom commands
    @customcmds : Strings

    getter data_filename : String

    def initialize
      Cryplot.plots_counter += 1
      @width = 0  # size of plot in x
      @height = 0 # size of plot in y
      @script_filename = "show#{Cryplot.plots_counter}.plt"
      @data_filename = "plot#{Cryplot.plots_counter}.dat"
      @data = ""       # current plot data as string
      @numdatasets = 0 # current number of data sets in the data file

      @font = Font.new
      @border = Border.new
      @grid = Grid.new
      @style_fill = FillStyle.new
      @legend = Legend.new
      @title = Title.new
      @drawspecs = Array(Draw).new
      @customcmds = Strings.new

      # Show only major and minor xtics and ytics
      # Default options for fill style
      @style_fill
        .solid
        .border_hide
    end

    # Set the palette of the colors for the plot.
    def palette(name : Cryplot::Palette)
      @palette = name
    end

    def autoclean(val : Bool)
      @autoclean = val
    end

    # Set the title text of the plot
    def title(text : String)
      @title.title(text)
    end

    # Set the size of the plot (in unit of points, with 1 inch = 72 points).
    def size(width : Int, height : Int)
      @width = width
      @height = height
    end

    # Set the font name for the plot (e.g., Helvetica, Georgia, Times).
    def font_name(name : String)
      @font.font_name(name)
      @legend.font_name(name)
    end

    # Set the font size for the plot (e.g., 10, 12, 16).
    def font_size(size : Int)
      @font.font_size(size)
      @legend.font_size(size)
    end

    # Draw plot object with given `using` and `with` expressions (e.g., `plot.draw("1:2", "points")`)).
    def draw(using : String, expr : String)
      draw("'#{@data_filename}'", using, expr)
    end

    # Draw plot object with given `what`, `using` and `with` expressions (e.g., `plot.draw("sin(x)*cos(x)", "", "linespoints")`,  (e.g., `plot.draw("file.dat", "1:2", "points")`)).
    def draw(what : String, using : String, expr : String)
      @drawspecs << Draw.new(what, using, expr)
      @drawspecs.last
    end

    def this
      self
    end

    def samples(value : Int)
      @samples = value.to_s
    end

    # Use this method to provide gnuplot commands to be executed before the plotting calls.
    def gnuplot(cmd : String)
      @customcmds << cmd
    end

    # Show the plot in a popup-window
    # Note: This removes temporary files after saving if `autoclean` is enabled. default is enabled
    def show
      script = File.new(@script_filename, mode: "w")
      # Add palette info.
      Gnuplot.palettecmd(script, palette)

      # Add terminal info
      width = @width == 0 ? Consts::DEFAULT_FIGURE_WIDTH : @width
      height = @height == 0 ? Consts::DEFAULT_FIGURE_HEIGHT : @height
      size = Gnuplot.sizestr(width, height, false)
      Gnuplot.showterminalcmd(script, size, @font.repr)

      # Add the plot commands
      script << self

      # Add an empty line at the end and close the script to avoid crashes with gnuplot
      script << Gnuplot::NEW_LINE
      script.close

      # save plot data to file
      save_plot_data

      # show the plot
      Gnuplot.runscript(@script_filename, true)

      # remove the temporary files if user wants to
      cleanup if autoclean
    end

    # Save the plot in a file, with its extension defining the file format.
    # The extension of the file name determines the file format
    # The supported formats are: `pdf`, `eps`, `svg`, `png`, and `jpeg`
    # Thus, to save a plot in `pdf` format, choose a file as in `plot.pdf`.
    # Note: This removes temporary files after saving if `autoclean` is enabled. default is enabled
    def save(filename : String)
      # Clean the file name to prevent errors
      cleanedfilename = Gnuplot.cleanpath(filename)

      # Get extension from file name
      if (idx = cleanedfilename.rindex('.'))
        extension = cleanedfilename[idx + 1..].downcase
      else
        extension = "pdf"
      end

      script = File.new(@script_filename, mode: "w")
      Gnuplot.palettecmd(script, palette)

      # Add terminal info
      width = @width == 0 ? Consts::DEFAULT_FIGURE_WIDTH : @width
      height = @height == 0 ? Consts::DEFAULT_FIGURE_HEIGHT : @height
      size = Gnuplot.sizestr(width, height, extension == "pdf")
      Gnuplot.saveterminalcmd(script, extension, size, @font.repr)

      # Add output command
      Gnuplot.outputcmd(script, cleanedfilename)

      # Add the plot commands
      script << self

      # Unset the output
      script << Gnuplot::NEW_LINE
      script << "set output"

      # Add an empty line at the end and close the script to avoid crashes with gnuplot
      script << Gnuplot::NEW_LINE
      script.close

      # save plot data to file
      save_plot_data

      # Save the plot as file
      Gnuplot.runscript(@script_filename, false)

      # remove the temporary files if user wants to
      cleanup if autoclean
    end

    # write the current plot data to data file
    def save_plot_data
      # Open data file, truncate it and write all current plot data to it
      unless @data.blank?
        File.write(@data_filename, @data, mode: "w")
      end
    end

    # Delete all files used to store plot data or scripts.
    def cleanup
      File.delete(@script_filename) rescue nil
      File.delete(@data_filename) rescue nil
    end

    # clear all draw and gnuplot commands
    # Note: This method leaves all other plot properties untouched.
    def clear
      @drawspecs.clear
      @customcmdss.clear
    end

    abstract def repr : String

    # convert this plot object into a gnuplot formatted string.
    def to_s(io : IO) : Nil
      io << repr
    end
  end

  # :nodoc:
  class_property plots_counter : Int32 = 0
end
