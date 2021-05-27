module Cryplot
  # :nodoc:
  module Gnuplot
    extend self

    {% if flag?(:windows) %}
      NEW_LINE = "\r\n"
    {% else %}
      NEW_LINE = "\n"
    {% end %}

    # Return formatted string for a plot title
    def title(word : String)
      word == "columnheader" ? word : "'#{word}'"
    end

    # Return the formatted string for a `command value` pair (e.g., "set xlabel 'Time'")
    # Note that if value is empty, then the command is not needed and an empty string is returned.
    def command_value_str(cmd : String, value : String)
      value.size > 0 ? "#{cmd} #{value}\n" : ""
    end

    def format(val)
      val.format(decimal_places: 5, only_significant: true)
    end

    # Return the formatted string for a size pair (x,y) in either as pixels or as inches (asinches == true).
    def sizestr(width, height, asinches : Bool)
      asinches ? "#{format(width * Cryplot::POINT_TO_INCHES)}in, #{format(height * Cryplot::POINT_TO_INCHES)}in" : "#{width},#{height}"
    end

    # Return the correct gnuplot string command for given rgb color (e.g., "#FF00FF")
    def rgb(color : String)
      "rgb '#{color}'"
    end

    # function to create a data set in an IO that is understood by gnuplot
    def writedataset(io : IO, index : Int, *args : Array) : IO
      # Save the given vectors x and y in a new data set of the data file
      io << "#==============================================================================" << NEW_LINE
      io << "# DATASET #" << index << NEW_LINE
      io << "#==============================================================================" << NEW_LINE

      # White the vector arguments to the IO
      write(io, *args)

      # Ensure two blank lines are added here so that gnuplot understands a new data set has been added
      io << "\n\n"
      io
    end

    # write palette data for a selected palette to start of plot script
    def palettecmd(io, palette)
      io << "#==============================================================================" << NEW_LINE
      io << "# GNUPLOT-palette (" << palette << ")" << NEW_LINE
      io << "#------------------------------------------------------------------------------" << NEW_LINE
      io << "# see more at https://github.com/Gnuplotting/gnuplot-palettes" << NEW_LINE
      io << "#==============================================================================" << NEW_LINE
      io << palette.data << NEW_LINE
      io
    end

    # write terminal commands for showing a plot from a script file
    def showterminalcmd(io, size, font)
      io << "#==============================================================================" << NEW_LINE
      io << "# TERMINAL" << NEW_LINE
      io << "#==============================================================================" << NEW_LINE
      # We set a terminal here to make sure we can also set a size. This is necessary, because the
      # canvas size can ONLY be set using "set terminal <TERMINAL> size W, H".
      # See: http://www.bersch.net/gnuplot-doc/canvas-size.html#set-term-size
      # The GNUTERM variable contains the default terminal, which we're using for the show command.
      # See: http://www.bersch.net/gnuplot-doc/unset.html
      io << "set termoption enhanced" << NEW_LINE
      unless font.blank?
        io << "set termoption #{font}" << NEW_LINE
      end
      io << "set terminal GNUTERM size " << size << NEW_LINE
      io << "set encoding utf8" << NEW_LINE
      io
    end

    # write terminal commands for saving a plot from a script file
    def saveterminalcmd(io, extension, size, font)
      io << "#==============================================================================" << NEW_LINE
      io << "# TERMINAL" << NEW_LINE
      io << "#==============================================================================" << NEW_LINE
      io << "set terminal " << extension << " size " << size << " enhanced rounded " << font << NEW_LINE
      io << "set encoding utf8" << NEW_LINE
      io
    end

    # function to set the output command to make GNUplot output plots to a file
    def outputcmd(io, filename)
      io << "#==============================================================================" << NEW_LINE
      io << "# OUTPUT" << NEW_LINE
      io << "#==============================================================================" << NEW_LINE
      io << "set output '" << filename << "'" << NEW_LINE
      io << "set encoding utf8" << NEW_LINE
      io
    end

    # function to write multiplot commands to a script file
    def multiplotcmd(io, rows, columns, title)
      io << "#==============================================================================" << NEW_LINE
      io << "# MULTIPLOT" << NEW_LINE
      io << "#==============================================================================" << NEW_LINE
      io << "set multiplot"
      unless rows == 0 && columns == 0
        io << " layout " << rows << "," << columns
      end
      io << " " << "rowsfirst"
      io << " " << "downwards"
      unless title.blank?
        io << " title '" << title << "'"
      end
      io << NEW_LINE
      io
    end

    # function to run gnuplot to show or save a script file
    # persistent == true: for show commands. show the file using GNUplot until the window is closed
    # persistent == false: for save commands. close gnuplot immediately
    def runscript(scriptfilename, persistent)
      cmd = persistent ? "gnuplot -persistent " : "gnuplot "
      cmd += "\"#{scriptfilename}\""
      system(cmd)
    end

    # function to escape a output path so it can be used for GNUplot.
    # Removes every character from invalidchars from the path.
    def cleanpath(path)
      invalidchars = ":*?!\"<>|"
      invalidchars.each_char do |c|
        path = path.gsub(c, "")
      end
      path
    end

    def escape_if_needed(val)
      return "'#{val}'" if val.is_a?(String)
      if f = val.as?(Float)
        return f.finite? ? f.to_s : Cryplot::MISSING_INDICATOR
      end
      val.to_s
    end

    def write_line(io, i, *args)
      args.each do |v|
        io << escape_if_needed(v[i]) << " "
      end
      io << "\n"
      io
    end

    def write(io, *args)
      size = minsize(*args)
      0.upto(size - 1) do |i|
        write_line(io, i, *args)
      end
    end

    #  function that returns the size of the vector argument with least size
    def minsize(*args : Array)
      args.map(&.size).min
    end
  end
end
