require "../src/cryplot"

x = Cryplot.range(0, 3)
y = [-4, 2, 5, -3] of Float64

Cryplot.plot {
  # set the legend and hide
  legend.hide

  # set the x and y labels
  xlabel("x")
  ylabel("y")

  # Set the y range
  yrange(-5, 5)

  # Add values to plot
  draw_boxes(x, y)
    .fill_solid
    .fill_color("green")
    .fill_intensity(0.5)

  # Adjust the relative width of the boxes
  box_width_relative(0.75)

  # Show the plot in a pop-up window
  show

  # save the plot to a png file
  save("example-boxes.png")
}
