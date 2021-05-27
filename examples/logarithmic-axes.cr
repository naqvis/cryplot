require "../src/cryplot"

# Create a vector with values from 1 to 12 divided into 100 uniform intervals for the x-axis
x = Cryplot.linspace(1, 12, 100)

Cryplot.plot {
  # Set the x and y labels
  xlabel("x")
  ylabel("y")

  # Set the x and y ranges
  xrange(1, 12)
  yrange(2, 4096)

  # Set the legend to be on the bottom along the horizontal
  legend
    .at_outside_bottom
    .display_horizontal
    .display_expand_width_by(2)

  ytics.logscale(2)

  # Plot 2 ** x
  draw_curve(x, x.map { |v| 2.0 ** v }).label("2 ** x")

  # Show the plot in a pop-up window
  size(749, 749)
  show

  # Save the plot to a SVG file
  save("example-logarithmic-axes.svg")
}
