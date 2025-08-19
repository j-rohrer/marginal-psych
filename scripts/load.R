# Load all required libraries for the psych project

library(brms)
library(dplyr)
library(marginaleffects)
library(haven)
library(splines)
library(ggplot2)
library(scales)
library(here)
library(ordinal)
library(parameters)
library(tinytable)
theme_set(theme_classic())
options(marginaleffects_safe = FALSE)
options(marginaleffects_print_type = FALSE)
if (!interactive()) {
  options(marginaleffects_print_style = "tinytable")
  options(width = 300)
}
knitr::opts_chunk$set(error = TRUE, echo = TRUE, warning = FALSE, message = FALSE)
knitr::opts_chunk$set(error = TRUE, echo = TRUE)
