############################################################
# Third-Variable Control When Evaluating Moderation Claims
############################################################

library(marginaleffects)

set.seed(12345)

n <- 50000

# Continuous treatment
x <- rnorm(n)

# Confounder of interaction
conf <- rnorm(n)
conf_noisy <- conf + rnorm(n, mean = 0, sd = 1)
  
# Moderator of interest
# has five levels to simplify things
mod <- as.numeric(cut(conf_noisy,
           breaks = c(-Inf, -1.5, -0.5, 0.5, 1.5, Inf),
           labels = 1:5))

cor.test(conf, mod)

# outcome
y <- 0.4*x + 0.2*conf + 0.2*x*conf + 0.3*mod + 0.15*mod*x + rnorm(n)
# a 1-unit increase of mod increases the effect of x by 0.15

summary(lm(y ~ x + conf + mod + x*conf + x*mod))
# the coefficient correctly recovers the causal interaction between mod and x
# per unit of mod, the effect of x on the outcome increases by 0.15


# Conditional ATE
regression <- lm(y ~ x + conf + mod + x*conf + x*mod)
avg_slopes(regression, variable = "x", by = "mod")

# Looking at consecutive values of mod, the difference in the slopes
# overestimates the effect of mod on the slopes of x
# this is because we are looking at the correlation between mod and the effect of x
# to recover the effect of mod on the effect of x, we need to condition on conf
# which specifically confounds the interaction

avg_slopes(regression,
           variables = "x", # cause of interest
           by = "mod", # variable to split by
           newdata = datagrid(mod = 1:5,
                              grid_type = "counterfactual"))

# this in contrast correctly reflects the causal effect of mod on the effect of x
