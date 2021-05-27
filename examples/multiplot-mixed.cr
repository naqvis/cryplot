require "../src/cryplot"

def create_helix_plot
  # Create a vector with values from 0 to 100 divived into 2000 uniform intervals for the z-axis
  z = Cryplot.linspace(0.0, 100.0, 2000)

  # construct x and y for each z so that a helix curve is defined
  x = Array(Float64).new(z.size)
  y = Array(Float64).new(z.size)
  c = 2.0
  r = 1.0

  z.each do |val|
    x << r * Math.cos(val / c)
    y << r * Math.sin(val / c)
  end

  # create a 3D plot
  plot = Cryplot.plot3d

  # draw the helix curve and set the label displayed in the legend
  plot.draw_curve(x, y, z)

  # disable legend for this plot
  plot.legend.hide

  # Set the x,y,z labels
  plot.xlabel("x")
  plot.ylabel("y")
  plot.zlabel("z")

  # Clear all borders and set the visible ones
  plot.border
    .clear
    .bottom_left_front
    .bottom_right_front
    .left_vertical

  plot
end

# Create a vector with values from 0 to 5 divived into 200 uniform intervals for the x-axis
x = Cryplot.linspace(0.0, 5.0, 200)

# Create 4 different plots
plot0 = Cryplot.plot
plot0.draw_curve(x, x.map { |v| Math.sin(v) }).label("sin(x)")
plot0.draw_curve(x, x.map { |v| Math.cos(v) }).label("cos(x)")

plot1 = Cryplot.plot
plot1.draw_curve(x, x.map { |v| Math.cos(v) }).label("cos(x)")

plot2 = Cryplot.plot
plot2.draw_curve(x, x.map { |v| Math.tan(v) }).label("tan(x)")

plot3 = create_helix_plot

# Use the previous plots as sub-figures in a larger 2x2 figure
Cryplot.figure([[plot0, plot1], [plot2, plot3]]) {
  size(600, 600)
  title("Mixing 2D and 3D plots")
  palette(:dark2)

  show

  save("example-multiplot-mixed.pdf")
}
