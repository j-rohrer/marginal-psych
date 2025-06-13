# Figure 2 Binary Logistic Regression
# Author: Julia Rohrer
# Date: Generated from Quarto document

source(here::here("scripts/load.R"))

# Overview
#
# In this document, we generate a simple illustration of how quantities can be calculated on different scales.

# Define the inverse logit function
inv_logit <- function(x) {
  exp(x) / (1 + exp(x))
}

# Create a data frame of log-odds
df <- data.frame(
  log_odds = seq(-5.5, 5.5, length.out = 500)
)

# Compute the corresponding probabilities
df$probability <- inv_logit(df$log_odds)

# Plot

# color scheme
color_prediction <- "#0072B2"
color_comparison <- "#56B4E9"
color_slope <- "#009E73"
color_neutral <- "#BBBBBB"

low_point <- 0
inv_logit(low_point)
high_point <- 4
inv_logit(high_point)

ggplot(df, aes(x = log_odds, y = probability)) +
  geom_line() +

  # Guideline prediction
  geom_segment(
    x = -10,
    xend = low_point,
    y = inv_logit(low_point),
    color = color_neutral,
    linetype = "dashed",
    alpha = .80
  ) +
  geom_segment(
    x = -10,
    xend = high_point,
    y = inv_logit(high_point),
    color = color_neutral,
    linetype = "dashed",
    alpha = .80
  ) +
  geom_segment(
    y = 0,
    yend = inv_logit(low_point),
    x = low_point,
    color = color_neutral,
    linetype = "dashed",
    alpha = .80
  ) +
  geom_segment(
    y = 0,
    yend = inv_logit(high_point),
    x = high_point,
    color = color_neutral,
    linetype = "dashed",
    alpha = .80
  ) +
  # Comparison
  geom_segment(
    x = low_point,
    xend = high_point,
    y = inv_logit(low_point),
    color = color_comparison,
    linetype = "solid"
  ) +
  geom_segment(
    x = high_point,
    y = inv_logit(low_point),
    yend = inv_logit(high_point),
    color = color_comparison,
    linetype = "solid"
  ) +
  # First prediction
  geom_point(
    x = low_point,
    y = inv_logit(low_point),
    color = color_prediction
  ) +
  # Second prediction
  geom_point(
    x = high_point,
    y = inv_logit(high_point),
    color = color_prediction
  ) +
  xlab("Log-odds scale") +
  ylab("Probability scale") +
  theme_classic()
ggsave(here("plots/logit_scale_raw.png"), width = 4, height = 3)
