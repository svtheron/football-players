# ============================================================
# Title:   Data Loading and Preparation
# Purpose: Load raw player data, filter to Big Five leagues,
#          and create the analytical dataset used in 02_analysis.R
# Inputs:  data/players_master.csv
# Outputs: players_big5 (tibble in environment)
# ============================================================

library(tidyverse)
library(ggridges)
library(scales)
library(paletteer)

# Source helper functions
invisible(lapply(list.files("R/", pattern = "\\.R$", full.names = TRUE), source))

players <- read_csv("data/players_master.csv", show_col_types = FALSE)

BIG5 <- c("England", "Spain", "Italy", "Germany", "France")

players_big5 <- players |>
  filter(
    country_name %in% BIG5,
    season >= 2004, season <= 2024,
    !is.na(market_value_eur)
  ) |>
  mutate(
    market_value_m = market_value_eur / 1e6,
    # Collapse rare/missing position labels
    position = if_else(position %in% c("Missing", NA_character_), NA_character_, position),
    league = factor(country_name, levels = BIG5)
  )

message(
  "Loaded ", nrow(players_big5), " player-season observations across ",
  n_distinct(players_big5$season), " seasons and ", n_distinct(players_big5$country_name),
  " leagues."
)
