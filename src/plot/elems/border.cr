require "bit_array"
require "./depth"
require "./line"

module Cryplot
  # Used to specific options for plot border
  class Border
    include LineMixin(Border)
    include DepthMixin(Border)

    # The placement depth of the borders
    @depth : String = ""
    # The bits encoding the active and inactive borders
    @encoding : BitArray

    def initialize
      @encoding = BitArray.new(13)
      left
      bottom
      line_type(Consts::DEFAULT_BORDER_LINETYPE)
      line_width(Consts::DEFAULT_BORDER_LINEWIDTH)
      line_color(Consts::DEFAULT_BORDER_LINECOLOR)
      front
    end

    # Remove all border edges from a 2d or 3d plot.
    def clear
      @encoding.each_with_index do |_, i|
        @encoding[i] = false
      end
      self
    end

    # Set all border edges to inactive. Methods none and clear have identical effect.
    def none
      clear
    end

    # Activate the bottom border edge on the xy plane for a 2d plot.
    def bottom
      @encoding[0] = true
      self
    end

    # Activate the left border edge on the xy plane for a 2d plot.
    def left
      @encoding[1] = true
      self
    end

    # Activate the top border edge on the xy plane for a 2d plot.
    def top
      @encoding[2] = true
      self
    end

    # Activate the right border edge on the xy plane for a 2d plot.
    def right
      @encoding[3] = true
      self
    end

    # Activate the border edge on the bottom xy plane going from the left corner to front corner in a 3d perspective.
    def bottom_left_front
      @encoding[0] = true
      self
    end

    # Activate the border edge on the bottom xy plane going from the left corder to back corner in a 3d perspective.
    def bottom_left_back
      @encoding[1] = true
      self
    end

    # Activate the border edge on the bottom xy plane going from the right corner to front corner in a 3d perspective.
    def bottom_right_front
      @encoding[2] = true
      self
    end

    # Activate the border edge on the bottom xy plane going from the right corder to back corner in a 3d perspective.
    def bottom_right_back
      @encoding[3] = true
      self
    end

    # Activate the left vertical border edge in a 3d perspective.
    def left_vertical
      @encoding[4] = true
      self
    end

    # Activate the back vertical border edge in a 3d perspective.
    def back_vertical
      @encoding[5] = true
      self
    end

    # Activate the right vertical border edge in a 3d perspective.
    def right_vertical
      @encoding[6] = true
      self
    end

    # Activate the front vertical border edge in a 3d perspective.
    def front_vertical
      @encoding[7] = true
      self
    end

    # Activate the border edge on the top xy plane going from the left corner to back corner in a 3d perspective.
    def top_left_back
      @encoding[8] = true
      self
    end

    # Activate the border edge on the top xy plane going from the right corder to back corner in a 3d perspective.
    def top_right_back
      @encoding[9] = true
      self
    end

    # Activate the border edge on the top xy plane going from the left corner to front corner in a 3d perspective.
    def top_left_front
      @encoding[10] = true
      self
    end

    # Activate the border edge on the top xy plane going from the right corder to front corner in a 3d perspective.
    def top_right_front
      @encoding[11] = true
      self
    end

    # Set the border for polar plot.
    def polar
      @encoding[2] = true
      self
    end

    def repr : String
      String.build do |sb|
        sb << "set border #{IO::ByteFormat::LittleEndian.decode(UInt16, @encoding.to_slice)}" << " "
        sb << depth_repr << " "
        sb << line_repr
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
