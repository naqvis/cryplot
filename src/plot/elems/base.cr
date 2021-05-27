module Cryplot
  # Base mixin
  module BaseMixin(T)
    # returns a string representation of object of some class
    abstract def repr : String

    def to_s(io : IO) : Nil
      io << repr
    end

    def derived : T
      self.as(T)
    end
  end
end
