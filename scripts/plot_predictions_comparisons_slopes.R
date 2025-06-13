# Figure 1 SOEP practice data
# Author: Julia Rohrer
# Date: Generated from Quarto document

source(here::here("scripts/load.R"))

# Overview
#
# In this document, we create illustrations to visualize the marginaleffects basics and terminology (Figure 1 in the manuscript).
# To do so, we analyze freely available practice data from the German Socio-Econmic Panel Study (SOEP).
# The data can be downloaded from the SOEP website (https://www.diw.de/en/diw_01.c.836543.en/soep_practice_dataset.html);
# we are using the English version (DOI: 10.5684/soep.practice.v36).

# Read the data and fit the model

# read data
soep <- read_dta(here("data/practice_en/practice_dataset_eng.dta"))
head(soep)

# fit simple model that predicts life satisfaction
mod <- lm(
  lebensz_org ~ sex * bs(alter, df = 3) * bs(einkommenj1, df = 3),
  data = soep[soep$alter < 60, ]
)
# this model is fairly flexible insofar that it flexibly models the effects of age and income
# and also allows for all interactions between the variables
# we limit ourselves to people under the age of 60

# let's take a look at the coefficients to confirm they are not easily interpretable
summary(mod)

# Querying the model
#
# In the manuscript, we illustrate the basic terminology with numbers.
# Let's actually generate those numbers from the model we fitted.

# Prediction: life satisfaction of a 35 year old woman who earns 20,000 euro
predictions(mod, newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000))
# Store value for plotting
prediction_20000 <- predictions(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000)
)$estimate


# Prediction: what if she earned twice as much
predictions(mod, newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 40000))
# Store value for plotting
prediction_40000 <- predictions(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 40000)
)$estimate

# Comparison: Compare these two predictions
comparisons(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000),
  variables = list("einkommenj1" = c(20000, 40000))
)

# Slope: How much does life satisfaction increase with income at 20000 euro
slopes(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000),
  variables = "einkommenj1"
)
# Store value for plotting
slope_20000 <- slopes(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000),
  variables = "einkommenj1"
)$estimate

# Let's translate this into life satisfaction points per 1,000 Euro
slopes(
  mod,
  newdata = data.frame(sex = 1, alter = 35, einkommenj1 = 20000),
  variables = "einkommenj1"
)$estimate *
  1000

# Illustrating the three quantities
#
# Let's illustrate this with some figures!
# The following code generates the panels underlying Figure 1.
#
# Panel A

# We could directly do this with the help of marginaleffects using the following:
plot_predictions(
  mod,
  newdata = data.frame(
    sex = 1,
    alter = 35,
    einkommenj1 = seq(from = 0, to = 80000, by = 10)
  ),
  by = "einkommenj1"
)

# However, we will also do this "manually" to separate the estimation from the plotting
# Just for ease of plot-optimization
# First step: Generate a data frame containing the same 35-year-old woman under different incomes
hypothetical_woman <- data.frame(
  sex = 1,
  alter = 35,
  einkommenj1 = seq(from = 0, to = 80000, by = 10)
)

# Let's generate her life satisfactions
hypothetical_predictions <- predictions(mod, newdata = hypothetical_woman)
head(hypothetical_predictions)

# Add the life satisfaction to the data we are going to plot
hypothetical_woman$lebensz_org <- hypothetical_predictions$estimate

# Let's plot!

# Little helper for customization: x-axis range over which the slope should be plotted
slope_range <- c(0, 60000)

# color scheme
color_prediction <- "#0072B2"
color_comparison <- "#56B4E9"
color_slope <- "#009E73"
color_neutral <- "#BBBBBB"

ggplot(data = hypothetical_woman, aes(x = einkommenj1, y = lebensz_org)) +
  # Line of the predicted values
  geom_line() +
  # Comparison
  geom_segment(
    x = 20000,
    xend = 40000,
    y = prediction_20000,
    color = color_neutral,
    linetype = "dashed"
  ) +
  geom_segment(
    x = 40000,
    y = prediction_20000,
    yend = prediction_40000,
    color = color_comparison,
    linetype = "solid"
  ) +
  # Slope
  geom_segment(
    x = slope_range[1],
    xend = slope_range[2],
    y = prediction_20000 - (20000 - slope_range[1]) * slope_20000,
    yend = prediction_20000 + (slope_range[2] - 20000) * slope_20000,
    color = color_slope
  ) +
  # Predictions
  geom_point(x = 20000, y = prediction_20000, color = color_prediction) +
  geom_point(x = 40000, y = prediction_40000, color = color_prediction) +
  # Layout and make it look nice
  xlab("Annual gross income") +
  ylab("Predicted life satisfaction") +
  coord_cartesian(ylim = c(7, 8.25)) +
  scale_x_continuous(
    labels = label_dollar(prefix = "", suffix = "€", big.mark = ",")
  )
ggsave(here("plots/predictions_comparisons_slopes.png"), width = 4, height = 3)
