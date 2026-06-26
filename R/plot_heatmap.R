# ============================================================
# Title:   Correlation heatmap utility
# Purpose: Visualise pairwise correlations for selected numeric columns
# Inputs:  data frame, variable names (unquoted, via ...), method string
# Outputs: A ggplot object
# ============================================================

plot_heatmap <- function(data, ..., method = "pearson") {
  cor_matrix <- data |>
    select(...) |>
    cor(method = method, use = "complete.obs")

  cor_long <- cor_matrix |>
    as.data.frame() |>
    rownames_to_column("var1") |>
    pivot_longer(-var1, names_to = "var2", values_to = "correlation")

  ggplot(cor_long, aes(x = var1, y = var2, fill = correlation)) +
    geom_tile() +
    geom_text(aes(label = round(correlation, 2)), size = 3) +
    scale_fill_gradient2(
      low = "blue", mid = "white", high = "red",
      midpoint = 0, limits = c(-1, 1),
      name = "Correlation"
    ) +
    labs(
      title = paste0("Correlation Heatmap (", method, ")"),
      x = NULL,
      y = NULL
    ) +
    my_theme()
}
