require "./base"
require "./line"
require "./depth"
require "./show"
require "../consts"

module Cryplot
  # class used to specific options for grid lines along axis tics (major or minor)
  class GridBase
    include LineMixin(GridBase)
    include DepthMixin(GridBase)
    include ShowMixin(GridBase)
    # The name of the tics for which the grid is affected
    @tics : String
    # The bool flag that indicates if the grid lines are along major tics, if true, or minor tics otherwise
    @majortics : Bool

    def initialize(@tics : String = "", @majortics : Bool = true)
      show(true)
      back()
      line_color(Consts::DEFAULT_GRID_LINECOLOR)
      line_width(Consts::DEFAULT_GRID_LINEWIDTH)
      line_type(Consts::DEFAULT_GRID_LINETYPE)
      dash_type(Consts::DEFAULT_GRID_DASHTYPE)
    end

    def repr : String
      show = show_repr
      visible = show != "no"
      return "unset grid" if @tics.blank? && !visible
      return "set grid no#{@tics}" if !@tics.blank? && !visible

      String.build do |sb|
        sb << "set grid #{@tics} "
        sb << depth_repr << " "
        if @majortics
          sb << line_repr
        else
          sb << ", " << line_repr # for minor tics, preceding comma is needed
        end
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end

  # class used to specify options for grid
  class Grid < GridBase
    # Array of grid specs for the major and minor grid lines in the plot (for xtics, ytics, mxtics, etc.)
    @gridtics : Array(GridBase)

    def initialize
      super("", true)
      @gridtics = Array(GridBase).new
      show(false)
      back()
    end

    # Return the specifications of the grid lines along major xtics on the bottom axis.
    def xtics
      xtics_major_bottom
    end

    # Return the specifications of the grid lines along major ytics on the left axis.
    def ytics
      ytics_major_left
    end

    # Return the specifications of the grid lines along major ztics.
    def ztics
      ztics_major
    end

    # Return the specifications of the grid lines along major rtics.
    def rtics
      rtics_major
    end

    # Return the specifications of the grid lines along major xtics on the bottom axis.
    def xtics_major_bottom
      gridmajor("xtics")
    end

    # Return the specifications of the grid lines along major xtics on the top axis.
    def xtics_major_top
      gridmajor("x2tics")
    end

    # Return the specifications of the grid lines along minor xtics on the bottom axis.
    def xtics_minor_bottom
      gridminor("mxtics")
    end

    # Return the specifications of the grid lines along minor xtics on the top axis.
    def xtics_minor_top
      gridminor("mx2tics")
    end

    # Return the specifications of the grid lines along major ytics on the left axis.
    def ytics_major_left
      gridmajor("ytics")
    end

    # Return the specifications of the grid lines along major ytics on the right axis.
    def ytics_major_right
      gridmajor("y2tics")
    end

    # Return the specifications of the grid lines along major ytics on the right axis.
    def ytics_minor_left
      gridminor("mytics")
    end

    # Return the specifications of the grid lines along major ytics on the left axis.
    def ytics_minor_right
      gridminor("my2tics")
    end

    # Return the specifications of the grid lines along major ztics.
    def ztics_major
      gridmajor("ztics")
    end

    # Return the specifications of the grid lines along minor ztics.
    def ztics_minor
      gridminor("mztics")
    end

    # Return the specifications of the grid lines along minor rtics.
    def rtics_major
      gridmajor("rtics")
    end

    # Return the specifications of the grid lines along minor rtics.
    def rtics_minor
      gridminor("mrtics")
    end

    def repr : String
      String.build do |sb|
        sb << super
        @gridtics.each do |grid|
          sb << "\n" << grid.repr
        end
      end
    end

    def to_s(io : IO) : Nil
      io << repr
    end

    private def gridmajor(tics)
      @gridtics << GridBase.new(tics, true)
      @gridtics.last
    end

    private def gridminor(tics)
      @gridtics << GridBase.new(tics, false)
      @gridtics.last
    end
  end
end
