require "../src/cryplot"
# Create a vector with values from 0 to 100 divived into 2000 uniform intervals for the z-axis
x = Cryplot.linspace(0.0, 100.0, 2000)

# create 4 different plots
plot0 = Cryplot.plot
plot0.draw_curve(x, x.map { |v| Math.sin(v) }).label("sin(x)")
plot0.draw_curve(x, x.map { |v| Math.cos(v) }).label("cos(x)")

plot1 = Cryplot.plot
plot1.draw_curve(x, x.map { |v| Math.cos(v) }).label("cos(x)")

plot2 = Cryplot.plot
plot2.draw_curve(x, x.map { |v| Math.tan(v) }).label("tan(x)")

plot3 = Cryplot.plot
plot3.draw_curve(x, x.map { |v| Math.sqrt(v) }).label("sqrt(x)")

# Use the previous plots as sub-figures in a larger 2x2 figure
Cryplot.figure([[plot0, plot1], [plot2, plot3]]) {
  size(600, 600)
  title("Trigonometric Functions")
  palette(:dark2)

  show

  save("example-multiplot.svg")
}
