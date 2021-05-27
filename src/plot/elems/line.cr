require "./base"

module Cryplot
  # mixin used to attach line options to a type
  module LineMixin(T)
    include BaseMixin(T)

    # line style of the underlying line object (e.g. "ls 2")
    @line_style : String = ""
    # The line type of the underlying line object (e.g., "lt 3").
    @line_type : String = ""
    # The line width of the underlying line object (e.g., "lw 2").
    @line_width : String = ""
    # The line color of the underlying line object (e.g., "lc rgb '#FF00FF'").
    @line_color : String = ""
    # The dash type of the underlying line object (e.g., "dt 2").
    @dash_type : String = ""

    # Set the line style of the underlying line object
    def line_style(val : Int32)
      @line_style = "linestyle #{val}"
      self.as(T)
    end

    # Set the line type of the underlying line object.
    def line_type(val : Int32)
      @line_type = "linetype #{val}"
      self.as(T)
    end

    # Set the line width of the underlying line object.
    def line_width(val : Int32)
      @line_width = "linewidth #{val}"
      self.as(T)
    end

    # Set the line color of the underlying line object.
    def line_color(color : String)
      @line_color = "linecolor '#{color}'"
      self.as(T)
    end

    # Set the dash type of the underlying line object
    def dash_type(val : Int32)
      @dash_type = "dashtype #{val}"
      self.as(T)
    end

    def line_repr : String
      String.build do |sb|
        sb << @line_style << " "
        sb << @line_type << " "
        sb << @line_width << " "
        sb << @line_color << " "
        sb << @dash_type << " "
      end.squeeze(' ').strip
    end
  end

  # class used to specific line options
  class Line
    include LineMixin(Line)

    def repr : String
      line_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
