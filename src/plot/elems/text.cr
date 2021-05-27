require "./base"
require "./font"
require "../consts"

module Cryplot
  # mixin used to attach text options to a type
  module TextMixin(T)
    include FontMixin(T)
    @color = "'#{Consts::DEFAULT_TEXTCOLOR}'"
    @enhanced = "enhanced"

    # set the color of the text (e.g., `"blue"`, `"#404040"`)
    def text_color(color : String) : T
      @color = "'#{color}'"
      self.as(T)
    end

    # set the enhanced mode of the text
    # The enhanced text mode allows superscript text to be represented as
    # `a^x`, subscript text with `a_x`, and combined sperscript and subscript
    # text with `a@^b_{cd}`.
    # For more details, read "Enhanced text mode" section of the Gnuplot manual.
    def enhanced(value : Bool) : T
      @enhanced = value ? "enhanced" : "noenhanced"
      self.as(T)
    end

    # convert this object into a gnuplot formatted string
    def text_repr : String
      String.build do |sb|
        sb << "#{@enhanced} textcolor #{@color}  "
        sb << font_repr
      end.squeeze(' ').strip
    end
  end

  class Text
    include TextMixin(Text)

    def repr : String
      text_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
