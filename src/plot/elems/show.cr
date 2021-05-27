require "./base"

module Cryplot
  # mixin used to attach visibility options to a type
  module ShowMixin(T)
    include BaseMixin(T)
    # The boolean flag that indicates if the plot element is shown or not.
    @show : Bool = true

    # :nodoc:
    def show_init
      show()
    end

    # Set the visibility status of the plot element
    def show(value = true)
      @show = value
      self.as(T)
    end

    # Set the visibility status of the plot element as hidden
    def hide
      show(false)
    end

    # Return true if the underlying plot element is hidden
    def hidden? : Bool
      !@show
    end

    def show_repr
      @show ? "" : "no"
    end
  end

  class Show
    include ShowMixin(Show)

    def repr : String
      show_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
