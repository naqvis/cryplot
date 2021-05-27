require "./base"

module Cryplot
  # mixin used to attach font options to a type
  module FontMixin(T)
    include BaseMixin(T)
    @fontname = ""
    @fontsize = 0

    # set the name of the font (e.g. Helvetica, Georgia, Times).
    def font_name(name : String) : T
      @fontname = name
      self.as(T)
    end

    # set the font size of the font (e.g. 10,12,16)
    def font_size(size : Int32) : T
      @fontsize = size
      self.as(T)
    end

    # convert this object into a gnuplot formatted string
    def font_repr : String
      return "" if @fontname.blank? && @fontsize == 0
      "font '#{@fontname},#{@fontsize unless @fontsize == 0}'"
    end
  end

  class Font
    include FontMixin(Font)

    def repr : String
      font_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
