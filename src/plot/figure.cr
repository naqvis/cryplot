require "./plot"
require "./plot3d"

module Cryplot
  alias PlotXD = Plot | Plot3D
  alias MultiPlots = Array(Array(PlotXD))

  # Class used to create multiple plots in one canvas
  class Figure
    # Counter of how many plot / singleplot objects have been instantiated in the application
    @@counter : Int32 = 0

    # The name of the gnuplot palette to be used
    @palette : Cryplot::Palette = Consts::DEFAULT_PALETTE
    # The font name and size used in the plots
    @font : Font
    # All the plots that have been added to figure
    @plots : Array(PlotXD)

    @layout_rows : Int32
    @layout_cols : Int32

    def initialize(plots : MultiPlots)
      @autoclean = true
      @font = Font.new
      @width = 0
      @height = 0
      @layout_rows = plots.size                      # the number of rows in the multiplot layout
      @layout_cols = plots.map(&.size).max           # max number of columns among all rows
      @title = ""                                    # title of the plot
      @script_filename = "multishow#{@@counter}.plt" # name of the file where the plot commands are saved
      @plots = plots.flatten.map(&.as(BasePlot))     # work-around

    end

    def autoclean(enable : Bool)
      @autoclean = enable
    end

    # Set the palette of the colors for the plot.
    def palette(name : Cryplot::Palette)
      @palette = name
      self
    end

    # Set the size of the plot (in unit of points, with 1 inch = 72 points).
    def size(width : Int, height : Int)
      @width = width
      @height = height
      self
    end

    # Set the font name for the plot (e.g., Helvetica, Georgia, Times).
    def font_name(name : String)
      @font.font_name(name)
    end

    # Set the font size for the plot (e.g., 10, 12, 16).
    def font_size(size : Int)
      @font.font_size(size)
    end

    def title(text : String)
      @title = text
      self
    end

    def save_plot_data
      @plots.each(&.save_plot_data)
    end

    # Show the plot in a popup-window
    # Note: This removes temporary files after saving if `autoclean` is enabled. default is enabled
    def show
      script = File.new(@script_filename, mode: "w")
      # Add palette info.
      Gnuplot.palettecmd(script, @palette)

      # Add terminal info
      width = @width == 0 ? Consts::DEFAULT_FIGURE_WIDTH : @width
      height = @height == 0 ? Consts::DEFAULT_FIGURE_HEIGHT : @height
      size = Gnuplot.sizestr(width, height, false)
      Gnuplot.showterminalcmd(script, size, @font.repr)

      # Add multiplot commands
      Gnuplot.multiplotcmd(script, @layout_rows, @layout_cols, @title)

      # Add the plot commands
      @plots.each do |p|
        script << p
      end

      # Add an empty line at the end and close the script to avoid crashes with gnuplot
      script << Gnuplot::NEW_LINE
      script.close

      # save plot data to file
      save_plot_data

      # show the figure
      Gnuplot.runscript(@script_filename, true)

      # remove the temporary files if user wants to
      cleanup if @autoclean
    end

    # Save the plots in a file, with its extension defining the file format.
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
      Gnuplot.palettecmd(script, @palette)

      # Add terminal info
      width = @width == 0 ? Consts::DEFAULT_FIGURE_WIDTH : @width
      height = @height == 0 ? Consts::DEFAULT_FIGURE_HEIGHT : @height
      size = Gnuplot.sizestr(width, height, extension == "pdf")
      Gnuplot.saveterminalcmd(script, extension, size, @font.repr)

      # Add output command
      Gnuplot.outputcmd(script, cleanedfilename)

      # Add the plot commands
      @plots.each do |p|
        script << p
      end

      # Close multiplot
      script << "unset multiplot" << Gnuplot::NEW_LINE

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
      cleanup if @autoclean
    end

    # Delete all files used to store plot data or scripts.
    def cleanup
      File.delete(@script_filename) rescue nil
      @plots.each(&.cleanup)
    end
  end
end
