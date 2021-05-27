require "./text"

module Cryplot
  # An axis label (e.g., xlabel, ylabel, etc.)
  class AxisLabel
    include TextMixin(AxisLabel)

    # axis label text (e.g. "Distance (km)")
    @text : String = ""
    # The rotation command to rotate teh label around
    @rotate : String = ""

    def initialize(@axis : String)
    end

    # set the text of the axis label
    def text(value : String)
      @text = "'#{value}'"
      self
    end

    # specific that the axis label should be rotated by a given angle in degrees
    def rotate_by(degrees : Int32)
      @rotate = "rotate by #{degrees}"
      self
    end

    # Specify that the axis label should be rotated to be in parallel to the corresponding axis (for 3D plots).
    def rotate_axis_parallel
      @rotate = "rotate parallel"
      self
    end

    # Specify that the axis label should not be rotated
    def rotate_none
      @rotate = "norotate"
      self
    end

    def repr : String
      return "" if @text.blank? && @rotate.blank?
      String.build do |sb|
        sb << "set #{@axis}label "
        sb << @text << " "
        sb << text_repr << " "
        sb << @rotate unless @rotate.blank?
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
