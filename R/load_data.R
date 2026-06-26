# ============================================================
# Title:   Generic CSV loader
# Purpose: Read one or more CSV files and bind into a single data frame
# Inputs:  path — a file path, directory, or vector of file paths
# Outputs: A tibble
# ============================================================

load_data <- function(path) {
  files <- if (length(path) > 1) {
    path
  } else if (dir.exists(path)) {
    list.files(path, pattern = "\\.csv$", full.names = TRUE)
  } else {
    path
  }

  if (length(files) == 0) stop("No CSV files found at: ", path)

  files |>
    purrr::map(readr::read_csv, show_col_types = FALSE) |>
    purrr::map(janitor::clean_names) |>
    purrr::list_rbind()
}
