# ============================================================
# Title:   Player Market Value Analysis
# Purpose: Answer the question: what drives market value in
#          European football? Five visualisations tracing
#          inflation, position, age, performance, and league.
# Inputs:  scripts/01_load.R (produces players_big5)
# Outputs: output/01_market_inflation.png
#          output/02_value_by_position.png
#          output/03_age_value_curves.png
#          output/04_goalscorer_premium.png
#          output/05_league_comparison.png
# ============================================================

source("scripts/01_load.R")

dir.create("output", showWarnings = FALSE)

# Colour palette: one colour per Big Five league
LEAGUE_COLOURS <- c(
  "England" = "#38003c",
  "Spain"   = "#ee8707",
  "Italy"   = "#024494",
  "Germany" = "#d00027",
  "France"  = "#002d62"
)

POSITION_COLOURS <- c(
  "Attack"     = "#e63946",
  "Midfield"   = "#457b9d",
  "Defender"   = "#2a9d8f",
  "Goalkeeper" = "#f4a261"
)

FONT <- "Atkinson Hyperlegible"


# ------------------------------------------------------------------------------
# Plot 1: The rising market
# Has money in football really exploded? Median market value per player,
# by league, across all available seasons.
# ------------------------------------------------------------------------------

p1_data <- players_big5 |>
  group_by(season, country_name) |>
  summarise(median_value_m = median(market_value_m, na.rm = TRUE), .groups = "drop")

p1 <- ggplot(p1_data, aes(x = season, y = median_value_m, colour = country_name)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  scale_y_continuous(
    labels = label_dollar(prefix = "€", suffix = "M", accuracy = 0.1)
  ) +
  scale_colour_manual(values = LEAGUE_COLOURS) +
  labs(
    title    = "The Rising Market: Player Values in Europe's Big Five (2004–2024)",
    subtitle = "Median market value per player, by league and season",
    x        = NULL,
    y        = "Median Market Value",
    colour   = "League",
    caption  = "Source: Transfermarkt"
  ) +
  my_theme(base_font = FONT)

ggsave("output/01_market_inflation.png", p1, width = 10, height = 6, dpi = 300)
message("Saved: 01_market_inflation.png")


# ------------------------------------------------------------------------------
# Plot 2: Position sets the baseline
# Not all positions are valued equally. Ridgeline plot of the full
# market value distribution by position for the 2023 season.
# ------------------------------------------------------------------------------

p2 <- players_big5 |>
  filter(season == 2023) |>
  drop_na(market_value_m, position) |>
  ggplot(aes(x = market_value_m, y = position, fill = position)) +
  geom_density_ridges(alpha = 0.75, scale = 1.2) +
  scale_x_log10(
    labels = label_dollar(prefix = "€", suffix = "M", accuracy = 1)
  ) +
  scale_fill_manual(values = POSITION_COLOURS) +
  labs(
    title    = "Strikers Cost More: Market Value Distribution by Position (2023)",
    subtitle = "Each ridge shows the full spread of market values in Europe's Big Five leagues",
    x        = "Market Value (€, log scale)",
    y        = NULL,
    caption  = "Source: Transfermarkt"
  ) +
  my_theme(base_font = FONT) +
  theme(legend.position = "none")

ggsave("output/02_value_by_position.png", p2, width = 10, height = 6, dpi = 300)
message("Saved: 02_value_by_position.png")


# ------------------------------------------------------------------------------
# Plot 3: The career arc
# Market value is not static — it follows a career arc that peaks at
# different ages depending on position. LOESS smooth over 2004–2024 pooled data.
# ------------------------------------------------------------------------------

p3 <- players_big5 |>
  filter(age >= 16, age <= 38) |>
  drop_na(age, market_value_m, position) |>
  ggplot(aes(x = age, y = market_value_m, colour = position)) +
  geom_smooth(method = "loess", se = TRUE, alpha = 0.12, linewidth = 1.2) +
  scale_y_log10(
    labels = label_dollar(prefix = "€", suffix = "M", accuracy = 1)
  ) +
  scale_colour_manual(values = POSITION_COLOURS) +
  labs(
    title    = "The Career Arc: Market Value Peaks at Different Ages by Position",
    subtitle = "Smoothed trajectory over 2004–2024 pooled data; shading shows 95% confidence interval",
    x        = "Age",
    y        = "Market Value (€, log scale)",
    colour   = "Position",
    caption  = "Source: Transfermarkt"
  ) +
  my_theme(base_font = FONT)

ggsave("output/03_age_value_curves.png", p3, width = 10, height = 6, dpi = 300)
message("Saved: 03_age_value_curves.png")


# ------------------------------------------------------------------------------
# Plot 4: The goalscorer premium
# Goals are the most visible currency in football. Among attackers,
# does scoring more — relative to appearances — translate to higher value?
# ------------------------------------------------------------------------------

p4 <- players_big5 |>
  filter(season == 2023, position == "Attack", appearances >= 5) |>
  drop_na(appearances, goals, market_value_m) |>
  ggplot(aes(x = appearances, y = goals, colour = market_value_m, size = market_value_m)) +
  geom_point(alpha = 0.65) +
  scale_colour_viridis_c(
    trans   = "log10",
    labels  = label_dollar(prefix = "€", suffix = "M", accuracy = 1),
    option  = "plasma",
    name    = "Market Value"
  ) +
  scale_size_continuous(range = c(1, 8), guide = "none") +
  labs(
    title    = "The Goalscorer Premium: Appearances, Goals, and Market Value",
    subtitle = "Attackers in Europe's Big Five leagues, 2023 season | Point size and colour reflect market value",
    x        = "Appearances",
    y        = "Goals",
    caption  = "Source: Transfermarkt"
  ) +
  my_theme(base_font = FONT)

ggsave("output/04_goalscorer_premium.png", p4, width = 10, height = 7, dpi = 300)
message("Saved: 04_goalscorer_premium.png")


# ------------------------------------------------------------------------------
# Plot 5: Does the league matter?
# Controlling for position, are certain leagues systematically
# richer in player value than others?
# ------------------------------------------------------------------------------

p5 <- players_big5 |>
  filter(season == 2023) |>
  drop_na(market_value_m, country_name) |>
  ggplot(
    aes(
      x    = market_value_m,
      y    = reorder(country_name, market_value_m, median),
      fill = country_name
    )
  ) +
  geom_boxplot(outlier.alpha = 0.25, outlier.size = 0.8) +
  scale_x_log10(
    labels = label_dollar(prefix = "€", suffix = "M", accuracy = 1)
  ) +
  scale_fill_manual(values = LEAGUE_COLOURS) +
  labs(
    title    = "Which League Pays Most? Market Value by League (2023)",
    subtitle = "Distributions ordered by median market value; outliers shown semi-transparent",
    x        = "Market Value (€, log scale)",
    y        = NULL,
    caption  = "Source: Transfermarkt"
  ) +
  my_theme(base_font = FONT) +
  theme(legend.position = "none")

ggsave("output/05_league_comparison.png", p5, width = 10, height = 6, dpi = 300)
message("Saved: 05_league_comparison.png")


message("\nAll figures saved to output/")
