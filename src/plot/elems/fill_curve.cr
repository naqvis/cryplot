require "./base"

module Cryplot
  # mixin used to set options for the gnuplot filledcurve functionality
  module FilledCurveMixin(T)
    include BaseMixin(T)

    # fill mode for curve(s)
    @fill_curve_mode : String = ""

    # limit filled area to above curves
    def above
      @fill_curve_mode = "above"
      self
    end

    # limit filled area to below curves
    def below
      @fill_curve_mode = "below"
      self
    end

    def filled_curve_repr
      " #{@fill_curve_mode}".squeeze(' ').strip
    end
  end

  class FilledCurve
    include FilledCurveMixin(FilledCurve)

    def repr : String
      filled_curve_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
