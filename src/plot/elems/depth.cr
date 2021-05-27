require "./base"

module Cryplot
  # mixin used to attach depth options to a type
  module DepthMixin(T)
    include BaseMixin(T)

    @depth = "back"

    # :nodoc:
    def depth_init
      back
    end

    # Set the underlying plot element to be displayed on the front of all plot elements.
    def front : T
      @depth = "front"
      self.as(T)
    end

    # Set the underlying plot element to be displayed on the back of all plot elements.
    def back : T
      @depth = "back"
      self.as(T)
    end

    # Set the underlying plot element to be displayed behind of all plot elements.
    # In 2D plots, this method is identical to @ref front.
    # In 3D plots, this method is applicable when in hidden mode.
    def behind : T
      @depth = "behind"
      self.as(T)
    end

    def depth_repr : String
      @depth
    end
  end

  class Depth
    include DepthMixin(Depth)

    def initialize
      depth_init
    end

    def repr : String
      depth_repr
    end
  end
end
