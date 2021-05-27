require "./base"

module Cryplot
  # mixin used to attach offset options to a type
  module OffsetMixin(T)
    include BaseMixin(T)

    # The offset of the title element along x direction.
    @xoffset = "0"
    # The offset of the title element along y direction.
    @yoffset = "0"

    # Shift the underlying plot element along the x direction by given number of characters (can be fraction).
    def shift_along_x(val : Number)
      @xoffset = val.to_s
      self.as(T)
    end

    # Shift the underlying plot element along the y direction by given number of characters (can be fraction).
    def shift_along_y(val : Number)
      @yoffset = val.to_s
      self.as(T)
    end

    # Shift the underlying plot element along the x direction within the graph coordinate system.
    def shift_along_graph_x(val : Number)
      @xoffset = "graph #{val}"
      self.as(T)
    end

    # Shift the underlying plot element along the y direction within the graph coordinate system.
    def shift_along_graph_y(val : Number)
      @yoffset = "graph #{val}"
      self.as(T)
    end

    # Shift the underlying plot element along the x direction within the screen coordinate system.
    def shift_along_screen_x(val : Number)
      @xoffset = "screen #{val}"
      self.as(T)
    end

    # Shift the underlying plot element along the y direction within the screen coordinate system.
    def shift_along_screen_y(val : Number)
      @yoffset = "screen #{val}"
      self.as(T)
    end

    def offset_repr
      offset = ""
      if @xoffset != "0" || @yoffset != "0"
        offset = "offset #{@xoffset}, #{@yoffset}"
      end

      offset.blank? ? "" : offset
    end
  end

  class Offset
    include OffsetMixin(Offset)

    def repr : String
      offset_repr
    end
  end
end
