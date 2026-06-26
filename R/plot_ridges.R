# ============================================================
# Title:   Ridgeline plot utility
# Purpose: Density ridgelines for one or more numeric variables
# Inputs:  data frame, variable names (unquoted, via ...), fill colour string
# Outputs: A ggplot object
# ============================================================

plot_ridges <- function(data, ..., fill = "steelblue") {
  data |>
    select(...) |>
    pivot_longer(everything(), names_to = "variable", values_to = "value") |>
    ggplot(aes(x = value, y = variable)) +
    geom_density_ridges(fill = fill, alpha = 0.7) +
    labs(title = "Density Plots", x = NULL, y = NULL) +
    my_theme()
}
