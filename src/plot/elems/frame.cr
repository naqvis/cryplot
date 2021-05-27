require "./base"
require "./line"
require "../consts"

module Cryplot
  # mixin used to attach frame options to a type
  module FrameMixin(T)
    include BaseMixin(T)
    # The visibility option for the frame
    @fshow : Bool = false
    # The line options for the frame
    @line : Line

    def initialize
      @line = Line.new
      frame_show(Consts::DEFAULT_LEGEND_FRAME_SHOW)
      frame_line_width(Consts::DEFAULT_LEGEND_FRAME_LINEWIDTH)
      frame_line_color(Consts::DEFAULT_LEGEND_FRAME_LINECOLOR)
      frame_line_type(Consts::DEFAULT_LEGEND_FRAME_LINETYPE)
    end

    # Set the visibility of the legend frame to a shown or hidden status.
    def frame_show(value = true)
      @fshow = value
      self.as(T)
    end

    # Set the visibility of the legend frame to a hidden status.
    def frame_hide
      frame_show(false)
    end

    # Set the line style of the legend frame
    def frame_line_style(value : Int32)
      @line.line_style(value)
      self.as(T)
    end

    # Set the line type of the legend frame
    def frame_line_type(value : Int32)
      @line.line_type(value)
      self.as(T)
    end

    # Set the line width of the legend frame
    def frame_line_width(value : Int32)
      @line.line_width(value)
      self.as(T)
    end

    # Set the line color the legend frame
    def frame_line_color(value : String)
      @line.line_color(value)
      self.as(T)
    end

    # Set the dash type of the legend frame
    def frame_dash_type(value : Int32)
      @line.dash_type(value)
      self.as(T)
    end

    def frame_repr
      return "nobox" unless @fshow
      "box #{@line.repr}"
    end
  end

  class Frame
    include FrameMixin(Frame)

    def repr : String
      frame_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
