# Stock Analysis Dashboard
# A comprehensive example showcasing new cryplot features:
# - Dual Y-axis for price and volume
# - Annotations for key events
# - Date/time axis formatting
# - Horizontal reference lines
# - Custom styling

require "../src/cryplot"

# Simulated stock data for 6 months
dates = [
  "2024-01-02", "2024-01-15", "2024-02-01", "2024-02-15", "2024-03-01",
  "2024-03-15", "2024-04-01", "2024-04-15", "2024-05-01", "2024-05-15",
  "2024-06-03", "2024-06-17", "2024-07-01",
]

# Stock price with realistic movement
prices = [150.0, 155.0, 148.0, 162.0, 158.0, 175.0, 180.0, 172.0, 185.0, 195.0, 188.0, 205.0, 215.0]

# Trading volume (in millions)
volume = [12.5, 15.2, 18.0, 14.3, 11.8, 22.5, 16.7, 19.2, 13.5, 25.0, 17.8, 28.5, 21.0]

# 50-day moving average (simplified)
ma50 = [148.0, 150.0, 149.0, 153.0, 154.0, 160.0, 167.0, 170.0, 174.0, 180.0, 183.0, 190.0, 198.0]

Cryplot.plot {
  title("ACME Corp (ACME) - 6 Month Analysis").title_font_size(14)

  # Time axis setup
  xtime_format("%Y-%m-%d")
  xtime_display("%b")
  xtics.rotate(-45)

  # Primary Y-axis: Price
  ylabel("Price ($)")
  yrange(140.0, 230.0)

  # Secondary Y-axis: Volume
  y2label("Volume (M)")
  y2range(0.0, 35.0)
  y2tics_show

  # Volume bars on secondary axis (draw first so they're behind)
  draw_boxes(dates, volume).label("Volume").line_color("#90CAF9").axes("x1y2")

  # Price line and moving average
  draw_curve(dates, prices).label("ACME Price").line_width(3).line_color("#2196F3")
  draw_curve(dates, ma50).label("50-day MA").line_width(2).line_color("#FF9800")

  # Key price levels
  hline(200, "lt 2 lw 1 lc '#4CAF50'") # Resistance
  hline(160, "lt 2 lw 1 lc '#f44336'") # Support

  # Annotate significant events
  annotate_graph(0.15, 0.25, "Earnings Beat", "font ',9' tc '#4CAF50'")
  annotate_graph(0.55, 0.65, "Product Launch", "font ',9' tc '#2196F3'")
  annotate_graph(0.85, 0.85, "All-Time High", "font ',9' tc '#9C27B0'")

  # Arrow pointing to breakout
  arrow_graph(0.42, 0.55, 0.38, 0.48, "head filled lw 1 lc '#FF9800'")

  # Styling
  grid.show.line_color("#e8e8e8")
  legend.at_top_left.display_vertical

  size(800, 500)
  save("stock-analysis.png")
}

puts "Generated: stock-analysis.png"
