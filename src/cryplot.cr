# Crystal plotting library powered by `gnuplot`
module Cryplot
  VERSION = "0.1.0"

  class UnkownPalette < Exception
    def initialize(name : String)
      super("Uknown palette name '#{name}' provided.")
    end
  end

  # returns a plot object
  def self.plot
    plot = Plot.new
    with plot yield plot
  end

  # returns a plot object
  def self.plot
    Plot.new
  end

  # returns a plot3d object
  def self.plot3d
    plot3d = Plot3D.new
    with plot3d yield plot3d
  end

  # returns a plot3d object
  def self.plot3d
    Plot3D.new
  end

  # returns a figure object
  def self.figure(plots : MultiPlots)
    fig = Figure.new(plots)
    with fig yield fig
  end

  # returns a figure object
  def self.figure(plots : MultiPlots)
    Figure.new(plots)
  end

  # Returns an array with uniform increments from a given initial value to a final one
  def self.linspace(x0 : T, x1 : T1, intervals : Int) : Array(Float64) forall T, T1
    res = Array(Float64).new(intervals + 1)
    0.upto(intervals - 1) do |i|
      res << x0 + i * (x1 - x0) / intervals.to_f
    end
    res
  end

  # Return an array with unit increment from a given initial value to a final one
  def self.range(x0 : Int, x1 : Int) : Array(Float64)
    incr = (x1 > x0) ? 1 : -1
    Array(Float64).new((x1 - x0).abs + 1) { |i| (x0 + i * incr).to_f }
  end
end

require "./plot/*"
