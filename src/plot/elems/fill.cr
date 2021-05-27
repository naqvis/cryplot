require "./base"

module Cryplot
  # mixin used to attach color or pattern fill options to a type
  module FillMixin(T)
    include BaseMixin(T)

    # The fill mode for the underlying object (e.g, "empty", "solid", "pattern").
    @fill_mode : String = ""
    # The fill color of the underlying object
    @fill_color : String = ""
    # The fill transparency of the underlying object (active or not).
    @transparent : String = ""

    # The fill intensity of the underlying object with respect to its border color.
    @density : String = ""

    # The fill pattern number of the underlying object.
    @pattern_number : String = ""

    # The border color of the underlying object.
    @bordercolor : String = ""

    # The border line width of the underlying object.
    @borderlinewidth : String = ""

    # The border show status of the underlying object.
    @bordershow : String = ""

    # Set an empty fill style for the underlying object.
    def fill_empty
      @fill_mode = "empty"
      self.as(T)
    end

    # Set a solid fill style for the underlying object.
    def fill_solid
      @fill_mode = "solid"
      self.as(T)
    end

    # Set a pattern fill style for the underlying object.
    def fill_pattern(num : Int32)
      @fill_mode = "pattern"
      @pattern_number = num.to_s
      self.as(T)
    end

    # Set the color for the solid or pattern fill of the underlying object.
    def fill_color(color : String)
      @fill_color = "fillcolor '#{color}'"
      self.as(T)
    end

    # Set the fill color intensity of the underlying object with respect to its border color (a value between 0.0 and 1.0).
    def fill_intensity(value : Float64)
      value = Math.min(Math.max(0, value), 1)
      @density = value.to_s
      @fill_mode = "solid"
      self.as(T)
    end

    # Set the fill of the underlying object to be transparent or not.
    def fill_transparent(active = true)
      @transparent = active ? "transparent" : ""
      @fill_mode = "solid" if @fill_mode.blank?
      self.as(T)
    end

    # Set the border line color of the underlying object.
    def border_line_color(color : String)
      @bordercolor = "'#{color}'"
      self.as(T)
    end

    # Set the border line width of the underlying object.
    def border_line_width(value : Int32)
      @borderlinewidth = value.to_s
      self.as(T)
    end

    # Set the border of the underlying object to be shown or not.
    def border_show(show = true)
      @bordershow = show ? "yes" : "no"
      self.as(T)
    end

    # Set the border of the underlying object to be hidden.
    def border_hide
      border_show(false)
    end

    def fill_repr
      fill_style = case @fill_mode
                   when "solid"
                     "fillstyle #{@transparent} solid #{@density}"
                   when "pattern"
                     "fillstyle #{@transparent} pattern #{@pattern_number}"
                   when "empty"
                     "fillstyle empty"
                   else
                     ""
                   end

      border_style = ""
      unless @bordershow.blank?
        if @bordershow == "yes"
          border_style = "border "
          border_style += "linecolor #{@bordercolor} " unless @bordercolor.blank?
          border_style += "linewidth #{@borderlinewidth} " unless @borderlinewidth.blank?
        else
          border_style = "noborder"
        end
      end

      String.build do |sb|
        sb << @fill_color << " "
        sb << fill_style << " "
        sb << border_style
      end.squeeze(' ').strip
    end
  end

  class Fill
    include FillMixin(Fill)

    def repr : String
      fill_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
