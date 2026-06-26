# ============================================================
# Title:   Density plot utility
# Purpose: Density curve for a single numeric column
# Inputs:  data frame, column name (unquoted)
# Outputs: A ggplot object
# ============================================================

plot_density <- function(data, col) {
  ggplot(data, aes(x = {{ col }})) +
    geom_density(alpha = 0.4) +
    labs(
      title = paste("Distribution of", deparse(substitute(col))),
      x     = deparse(substitute(col)),
      y     = "Density"
    ) +
    my_theme()
}
