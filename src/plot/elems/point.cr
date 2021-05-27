require "./base"

module Cryplot
  # mixin used to attach point options to a type
  module PointMixin(T)
    include BaseMixin(T)
    # The point type of the underlying plot object (e.g., "pt 3").
    @pointtype : String = ""
    # The point width of the underlying plot object (e.g., "ps 2").
    @pointsize : String = ""

    # Set the point type of the underlying plot object.
    def point_type(value : Int32)
      @pointtype = "pointtype #{value}"
      self.as(T)
    end

    # Set the point size of the underlying plot object.
    def point_size(value : Int32)
      @pointsize = "pointsize #{value}"
      self.as(T)
    end

    def point_repr
      "#{@pointtype} #{@pointsize}".strip
    end
  end

  class Point
    include PointMixin(Point)

    def repr : String
      point_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
