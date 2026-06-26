# ============================================================
# Title:   Scatter plot utility
# Purpose: Scatter plot of two numeric columns with a linear trend line
# Inputs:  data frame, x column, y column (unquoted)
# Outputs: A ggplot object
# ============================================================

plot_scatter <- function(data, x, y) {
  ggplot(data, aes(x = {{ x }}, y = {{ y }})) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE) +
    labs(
      title = paste(deparse(substitute(y)), "vs", deparse(substitute(x))),
      x     = deparse(substitute(x)),
      y     = deparse(substitute(y))
    ) +
    my_theme()
}
