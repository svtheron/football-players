# ============================================================
# Title:   Data inspection utility
# Purpose: Print a structured summary of any data frame
# Inputs:  A data frame
# Outputs: Printed summaries (categorical, numeric, other)
# ============================================================

inspect_data <- function(data) {
  categorical_summary <- data |>
    dplyr::select(dplyr::where(\(x) is.factor(x) || is.character(x))) |>
    purrr::imap_dfr(\(col, name) {
      tibble::tibble(
        column      = name,
        type        = class(col)[1],
        obs         = sum(!is.na(col)),
        n_missing   = sum(is.na(col)),
        pct_missing = round(mean(is.na(col)) * 100, 1),
        n_unique    = dplyr::n_distinct(col, na.rm = TRUE)
      )
    })

  numeric_summary <- data |>
    dplyr::select(dplyr::where(is.numeric)) |>
    purrr::imap_dfr(\(col, name) {
      tibble::tibble(
        column      = name,
        type        = class(col)[1],
        obs         = sum(!is.na(col)),
        n_missing   = sum(is.na(col)),
        pct_missing = round(mean(is.na(col)) * 100, 1),
        min         = round(min(col, na.rm = TRUE), 2),
        mean        = round(mean(col, na.rm = TRUE), 2),
        median      = round(median(col, na.rm = TRUE), 2),
        max         = round(max(col, na.rm = TRUE), 2),
        sd          = round(sd(col, na.rm = TRUE), 2)
      )
    })

  other_summary <- data |>
    dplyr::select(dplyr::where(\(x) !(is.numeric(x) || is.factor(x) || is.character(x)))) |>
    purrr::imap_dfr(\(col, name) {
      tibble::tibble(
        column      = name,
        type        = class(col)[1],
        obs         = sum(!is.na(col)),
        n_missing   = sum(is.na(col)),
        pct_missing = round(mean(is.na(col)) * 100, 1)
      )
    })

  cat("Categorical variables:\n")
  print(categorical_summary, n = Inf)
  cat("\nNumeric variables:\n")
  print(numeric_summary, n = Inf)

  if (nrow(other_summary) > 0) {
    cat("\nOther variables (not numeric/categorical):\n")
    print(other_summary, n = Inf)
  }

  invisible(list(
    categorical = categorical_summary,
    numeric     = numeric_summary,
    other       = other_summary
  ))
}
