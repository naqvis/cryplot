# Scientific Data Visualization
# Demonstrates scatter plots with color/size mapping, log scales,
# annotations, and error bars - common in scientific publications.

require "../src/cryplot"

# Simulated experimental data: particle energy vs detection rate
# with measurement uncertainty
n = 30
energies = (0...n).map { |i| 10.0 * (1.5 ** (i / 5.0)) } # Exponential spacing
rates = energies.map { |e| 1000.0 / (1.0 + (e / 100.0) ** 1.5) + (e % 7) * 5 }
uncertainties = rates.map { |r| r * 0.08 + 5.0 } # 8% + baseline error
intensity = energies.map { |e| Math.log10(e) }   # Color by log(energy)

Cryplot.plot {
  title("Particle Detection Rate vs Energy").title_font_size(14)
  xlabel("Energy (keV)")
  ylabel("Detection Rate (counts/s)")

  # Log scale for energy axis
  xlog
  xrange(10.0, 10000.0)
  yrange(0.0, 1200.0)

  # Scatter with color mapping by intensity
  draw_scatter_color(energies, rates, intensity).label("Measurements")

  # Error bars (separate layer)
  draw_error_bars_y(energies, rates, uncertainties).label_none.line_color("#666666")

  # Theoretical curve
  theory_x = Cryplot.linspace(10.0, 10000.0, 200)
  theory_y = theory_x.map { |e| 1000.0 / (1.0 + (e / 100.0) ** 1.5) }
  draw_curve(theory_x, theory_y).label("Theory").line_width(2).line_color("#e74c3c")

  # Annotate regions
  annotate(30, 900, "Low Energy Region", "font ',9' tc '#3498db'")
  annotate(1000, 200, "High Energy Tail", "font ',9' tc '#e74c3c'")

  # Reference line at half-maximum
  hline(500, "lt 2 lw 1 lc '#95a5a6'")
  annotate(15, 520, "Half-max", "font ',8' tc '#7f8c8d'")

  # Color palette for scatter
  gnuplot("set palette defined (1 '#3498db', 2 '#9b59b6', 3 '#e74c3c')")
  gnuplot("set colorbox")

  grid.show.line_color("#ecf0f1")
  legend.at_top_right

  size(700, 500)
  save("scientific-scatter.png")
}

puts "Generated: scientific-scatter.png"
