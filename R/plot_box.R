# ============================================================
# Title:   Boxplot utility
# Purpose: Horizontal boxplots for one or more numeric variables
# Inputs:  data frame, variable names (unquoted, via ...)
# Outputs: A ggplot object
# ============================================================

plot_box <- function(data, ...) {
  data |>
    select(...) |>
    pivot_longer(everything(), names_to = "variable", values_to = "value") |>
    ggplot(aes(x = value, y = variable)) +
    geom_boxplot() +
    labs(title = "Boxplots", x = NULL, y = NULL) +
    my_theme()
}
