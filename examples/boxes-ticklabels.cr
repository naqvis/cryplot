require "../src/cryplot"

names = ["John", "Peter", "Thomas", "Marta"]
ages = [44, 27, 35, 20]
experiences = [0.8, 0.4, 0.7, 0.9]

Cryplot.plot {
  # set the legend to the top left corner of the plot
  legend.at_top_left

  # set the y label and its range
  ylabel("Age")
  yrange(0.0, 50)

  # Plot the boxes using y values
  draw_boxes(names, ages, experiences)
    .fill_solid
    .fill_color("pink")
    .fill_intensity(0.5)
    .border_show
    .label_none

  # Adjust the relative width of the boxes
  box_width_relative(0.75)
  # autoclean(false)

  # Show the plot in a pop-up window
  show

  # save the plot to a pdf file
  save("boxes-ticklabels.pdf")
}
