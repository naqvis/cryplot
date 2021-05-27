require "./base"
require "./text"
require "./offset"
require "./show"
require "../consts"

module Cryplot
  # The class used to attach common tic options to a type that also specifies tic options.
  module BaseTics(T)
    include TextMixin(T)
    include OffsetMixin(T)
    include ShowMixin(T)

    # The option indicating if tics are displayed along axis or border.
    @along = ""

    # The mirror option of the tics.
    @mirror = ""

    # The rotate option for the tics.
    @rotate = ""

    # The place where the tics are displayed (in or out).
    @inout = ""

    # The format expression for formatting the display of the tics.
    @format = ""

    # The scale of the major tics.
    @scalemajor = 1.0

    # The scale of the minor tics.
    @scaleminor = 1.0

    # Logarithmic scaling base settings for the axis.
    @logscale_base = ""

    def initialize
      show_init
      along_border()
      mirror(Consts::DEFAULT_TICS_MIRROR)
      outside_graph()
      rotate(Consts::DEFAULT_TICS_ROTATE)
      scale_major_by(Consts::DEFAULT_TICS_SCALE_MAJOR_BY)
      scale_minor_by(Consts::DEFAULT_TICS_SCALE_MINOR_BY)
    end

    # Set the tics to be displayed along the axis.
    def along_axis
      @along = "axis"
      self.as(T)
    end

    # Set the tics to be displayed along the border.
    def along_border
      @along = "border"
      self.as(T)
    end

    # Set the tics to be mirrored on the opposite border if `true`.
    def mirror(value = true)
      @mirror = value ? "mirror" : "nomirror"
      self.as(T)
    end

    # Set the tics to be displayed inside the graph.
    def inside_graph
      @inout = "in"
      self.as(T)
    end

    # Set the tics to be displayed outside the graph.
    def outside_graph
      @inout = "out"
      self.as(T)
    end

    # Set the tics to be rotated by 90 degrees if `true`.
    def rotate(value = true)
      @rotate = value ? "rotate" : "norotate"
      self.as(T)
    end

    # Set the tics to be rotated by given degrees.
    def rotate_by(degrees : Number)
      @rotate = "rotate by #{degrees}"
      self.as(T)
    end

    # Set the scale for the major tics (identical to method scaleMajorBy).
    def scale_by(value : Number)
      scale_major_by(value)
    end

    # Set the scale for the major tics.
    def scale_major_by(value : Number)
      @scalemajor = value
      self.as(T)
    end

    # Set the scale for the minor tics.
    def scale_minor_by(value : Number)
      @scaleminor = value
      self.as(T)
    end

    # Set the format of the tics using a format expression (`"%.2f"`)
    def format(fmt : String)
      @format = "'#{fmt}'"
      self.as(T)
    end

    # Set logarithmic scale with base for an axis.
    def logscale(base = 10)
      @logscale_base = base.to_s
      self.as(T)
    end

    def tics_base_repr : String
      repr("")
    end

    def repr(axis : String) : String
      show = show_repr
      return "unset #{axis}tics" if show == "no"
      String.build do |sb|
        unless @logscale_base.blank?
          sb << "set logscale #{axis} #{@logscale_base}\n"
        end
        sb << "set " << axis << "tics" << " "
        sb << @along << " "
        sb << @mirror << " "
        sb << @inout << " "
        sb << "scale " << @scalemajor << "," << @scaleminor << " "
        sb << @rotate << " "
        sb << offset_repr << " "
        sb << text_repr << " "
        sb << @format
      end.squeeze(' ').strip
    end
  end

  # The class used to specify options for tics.
  class Tics
    include BaseTics(Tics)
    # The depth where the tics are displayed (back or front).
    @depth : String

    def initialize
      super
      @depth = "front"
    end

    def stack_front
      @depth = "front"
      self
    end

    def stack_back
      @depth = "back"
    end

    def repr : String
      base = tics_base_repr
      return base if hidden?

      "#{base} #{@depth}"
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end

  # The class used to specify options for major tics of a specific axis.
  class MajorTics
    include BaseTics(MajorTics)
    # The name of the axis associated with these tics
    @axis : String
    # The start value for tics
    @start = ""
    # The increment for the tics
    @increment = ""
    # The end value for the tics
    @end = ""
    # The values/labels of the tics that should be displayed
    @at = ""
    # The extra values/labels of the tics to be displayed
    @add = ""

    def initialize(@axis)
      super()
      raise ArgumentError.new("You have provided an empty string in `axis` argument") if @axis.blank?
    end

    # Set the values of the tics to be identified automatically.
    def automatic
      # clear strings related to tics values/labels
      @start = ""
      @end = ""
      @increment = ""
      @at = ""
      self
    end

    # Set the start value for the tics (you must also call method @ref increment).
    def start(value : Float64)
      @start = "#{value}, "
      @at = @start + @increment + @end
      self
    end

    # Set the increment for the tics (start and end values determined automatically).
    def increment(value : Float64)
      @increment = value.to_s
      @at = @start + @increment + @end
      self
    end

    # Set the end value for the tics (you must also call methods @ref start and  @ref increment).
    def end(value : Float64)
      @end = ", #{value}"
      @at = @start + @increment + @end
      self
    end

    # Set the start, increment and end values of the tics.
    def interval(start : Float64, increment : Float64, end_ : Float64)
      raise ArgumentError.new("The increment argment must be positive") if increment <= 0.0
      raise ArgumentError.new("The end_ argument must be greater than start") if end_ <= start
      @at = "#{start}, #{increment}, #{end_}"
      self
    end

    # Set the values of the tics that should be displayed.
    def at(values : Array(Float64))
      @at = String.build do |sb|
        sb << "("
        values.each_with_index do |v, i|
          sb << (i == 0 ? "" : ", ") << v
        end
        sb << ")"
      end
      self
    end

    # Set the labels that should be displayed on given tic values.
    def at(values : Array(Float64), labels : Array(String))
      raise ArgumentError.new("values and labels should of same size") if values.size < labels.size
      @at = String.build do |sb|
        sb << "("
        values.each_with_index do |v, i|
          sb << (i == 0 ? "" : ", ") << "'#{labels[i]}' #{v}"
        end
        sb << ")"
      end
      self
    end

    # Add more tics to be displayed with given tic values.
    def add(values : Array(Float64))
      @add = String.build do |sb|
        sb << "add ("
        values.each_with_index do |v, i|
          sb << (i == 0 ? "" : ", ") << v
        end
        sb << ")"
      end
      self
    end

    # Add more tics to be displayed with given tic values and corresponding labels.
    def add(values : Array(Float64), labels : Array(String))
      raise ArgumentError.new("values and labels should of same size") if values.size < labels.size
      @add = String.build do |sb|
        sb << "add ("
        values.each_with_index do |v, i|
          sb << (i == 0 ? "" : ", ") << "'#{labels[i]}' #{v}"
        end
        sb << ")"
      end
      self
    end

    def repr : String
      base = repr(@axis)
      return base if hidden?

      raise "You have called start method but not increment" if @start.size > 0 && @increment.blank?
      raise "You have called end method but not increment" if @end.size > 0 && @increment.blank?
      raise "You have called end method but not start" if @end.size > 0 && @start.blank?

      String.build do |sb|
        sb << base << " "
        sb << @at << " "
        sb << @add << " "
      end.squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end

  # The class used to specify options for minor tics of a specific axis.
  class MinorTics
    include BaseTics(MinorTics)
    # The name of the axis associated with these tics.
    @axis : String
    # The frequency of minor tics between major tics (number of minor tics = frequency - 1).
    @frequency = ""

    def initialize(@axis)
      super()
      raise ArgumentError.new("You have provided an empty string in `axis` argument") if @axis.blank?
    end

    # Set the number of minor tics between major tics to be identified automatically.
    def automatic
      @frequency = ""
      self
    end

    # Set the number of minor tics between major tics.
    def number(value : Int32)
      @frequency = Math.max(value + 1, 0).to_s
      self
    end

    def repr : String
      return "unset m#{@axis}tics" if hidden?
      "set m#{@axis}tics #{@frequency}".squeeze(' ').strip
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
