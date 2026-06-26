# ============================================================
# Title:   Bar chart utility
# Purpose: Horizontal bar chart of counts for a categorical column
# Inputs:  data frame, column name (unquoted)
# Outputs: A ggplot object
# ============================================================

plot_bar <- function(data, col) {
  data |>
    filter(!is.na({{ col }})) |>
    count({{ col }}, sort = TRUE) |>
    ggplot(aes(x = n, y = reorder({{ col }}, n))) +
    geom_col() +
    labs(
      title = paste("Counts of", deparse(substitute(col))),
      x     = "Count",
      y     = deparse(substitute(col))
    ) +
    my_theme()
}
