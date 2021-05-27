require "../src/cryplot"

# Create a vector with values from 0 to 5 divived into 100 uniform intervals for the z-axis
x = Cryplot.linspace(0.0, 5.0, 100)

# Create a plot object
Cryplot.plot {
  # set color palette
  palette(:dark2)

  # Draw a sine graph putting x on the x-axis and sin(x) on the y-axis
  draw_curve(x, x.map { |v| Math.sin(v) }).label("sin(x)").line_width(4)

  # Draw a cosine graph putting x on the x-axis and cos(x) on the y-axis
  draw_curve(x, x.map { |v| Math.cos(v) }).label("cos(x)").line_width(4)

  # Show the plot in a pop-up window
  show

  # Save the plot a PDF file
  save("plot-dark2.svg")
}
