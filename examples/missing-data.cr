require "../src/cryplot"

# Create vectors with some missing y values
x = [0, 1, 2, 3, 4, 5, 6, 7] of Float64
y = [3.2, 7.3, Float64::NAN, 2.8, 8.9, Float64::NAN, 5.0, 1.8]

Cryplot.plot {
  # disables the deletion of created gnuplot script and data file
  autoclean(false)

  # plot the data
  draw_broken_curve_with_points(x, y).label("broken lines")

  # Save the plot
  save("example-missing-data.pdf")
}
