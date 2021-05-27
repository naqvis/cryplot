require "../src/cryplot"

# Create a vector with values from 0 to pi divived into 200 uniform intervals for the x-axis
x = Cryplot.linspace(0.0, Cryplot::PI, 200)

Cryplot.plot {
  xlabel("x")
  ylabel("y")

  xrange(0.0, Cryplot::PI)
  yrange(0.0, 1.0)
  legend
    .at_outside_bottom
    .display_horizontal
    .display_expand_width_by(2)

  # Plot sin(i*x) from i = 1 to i = 6
  draw_curve(x, x.map { |v| Math.sin(1.0 * v) }).label("sin(x)")
  draw_curve(x, x.map { |v| Math.sin(2.0 * v) }).label("sin(2x)")
  draw_curve(x, x.map { |v| Math.sin(3.0 * v) }).label("sin(3x)")
  draw_curve(x, x.map { |v| Math.sin(4.0 * v) }).label("sin(4x)")
  draw_curve(x, x.map { |v| Math.sin(5.0 * v) }).label("sin(5x)")
  draw_curve(x, x.map { |v| Math.sin(6.0 * v) }).label("sin(6x)")

  show

  save("example-sine-functions.svg")
}
