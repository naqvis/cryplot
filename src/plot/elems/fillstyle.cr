require "./base"

module Cryplot
  # class used to attach color or pattern fill options to a type
  class FillStyle
    include BaseMixin(FillStyle)

    # The fill mode for the underlying object (e.g, "empty", "solid", "pattern").
    @fillmode : String = ""

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
    def empty
      @fillmode = "empty"
      self
    end

    # Set a solid fill style for the underlying object.
    def solid
      @fillmode = "solid"
      self
    end

    # Set a pattern fill style for the underlying object.
    def pattern(num : Int32)
      @fillmode = "pattern"
      @pattern_number = num.to_s
      self
    end

    # Set the fill color intensity of the underlying object with respect to its border color (a value between 0.0 and 1.0).
    def intensity(value : Float64)
      @fillmode = "solid"
      @density = Math.min(Math.max(0, value), 1).to_s
      self
    end

    # Set the fill of the underlying object to be transparent or not.
    def transparent(active = true)
      @transparent = active ? "transparent" : ""
      @fillmode = "solid" if @fillmode.blank?
      self
    end

    # Set the border line color of the underlying object.
    def border_line_color(color : String)
      @bordercolor = "'#{color}'"
      self
    end

    # Set the border line width of the underlying object.
    def border_line_width(value : Int32)
      @borderlinewidth = value.to_s
      self
    end

    # Set the border of the underlying object to be shown or not.
    def border_show(show = true)
      @bordershow = show ? "yes" : "no"
      self
    end

    # Set the border of the underlying object to be hidden.
    def border_hide
      border_show(false)
    end

    def repr : String
      fill_style = case @fillmode
                   when "solid"
                     "#{@transparent} solid #{@density}"
                   when "pattern"
                     "#{@transparent} pattern #{@pattern_number}"
                   when "empty"
                     "empty"
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

      return "" if fill_style.blank? && border_style.blank?

      String.build do |sb|
        sb << "set style fill "
        sb << fill_style << " "
        sb << border_style
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
