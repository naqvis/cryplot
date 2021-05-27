require "../src/cryplot"

# Create a vector with values from 0 to 2*pi divided into 200 uniform intervals for the x-axis
x = Cryplot.linspace(0.0, 2.0 * Cryplot::PI, 200)

plot0 = Cryplot.plot
plot1 = Cryplot.plot
plot2 = Cryplot.plot

# Plot sine functions
plot0.draw_curves_filled(x, x.map { |v| Math.sin(v * 1.0) }).label("sin(x) default")
plot1.draw_curves_filled(x, x.map { |v| Math.sin(v * 1.0) }, x.map { |v| Math.sin(v * 2.0) })
  .fill_color("red")
  .label("sin(x) \\& sin(2x) default")
plot2.draw_curves_filled(x, x.map { |v| Math.sin(v * 1.0) }, x.map { |v| Math.sin(v * 2.0) }).above
  .fill_color("blue")
  .label("sin(x) \\& sin(2x) above")
plot2.draw_curves_filled(x, x.map { |v| Math.sin(v * 1.0) }, x.map { |v| Math.sin(v * 2.0) }).below
  .fill_color("orange")
  .label("sin(x) \\& sin(2x) below")

# Use the previous plots as sub-figures in a larger figure
Cryplot.figure([[plot0, plot1], [plot2]]) {
  title("Filled curves \\& options")
  palette(:dark2)
  size(749, 749)

  # Show the plot in a pop-up window
  show
  save("example-filled-curves.pdf")
}
