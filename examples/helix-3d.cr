require "../src/cryplot"

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

# Create a Plot3D object
Cryplot.plot3d {
  # Set the x,y,z labels
  xlabel("x")
  ylabel("y")
  zlabel("z")

  # Clear all borders and set the visible ones
  border.clear
  border.bottom_left_front
  border.bottom_right_front
  border.left_vertical

  # This disables the deletion of created gnuplot script and data file
  autoclean(false)

  # Change its palette
  palette(:dark2)

  # Draw the helix curve
  draw_curve(x, y, z).label("helix").line_color("orange")

  # show the plot in a pop-up window
  show

  # Save the plot to a png file
  save("example-helix-3d.png")
}
