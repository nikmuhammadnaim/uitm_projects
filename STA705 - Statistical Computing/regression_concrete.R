# --------------------------------------------
# Data Loading
# --------------------------------------------

concrete <- read.csv("slump_test.csv")
str(concrete)

sum(is.na(concrete))


# --------------------------------------------
# Descriptive Statistics
# --------------------------------------------

library(pastecs)

# List out interested descriptive statistics
interest <- c("min", "max", "mean", "std.dev", "coef.var", "skewness", "kurtosis")

# Run the stat.desc() and choose only relevant rows
concrete.stat <- stat.desc(concrete[-1], norm = TRUE)[interest, ]

# Round-off to 3 decimal places for better visualization
concrete.stat <- round(concrete.stat, 3)

# Display the output
concrete.stat


# Find the correlation between each input
library(psych)

pairs.panels(concrete[-1])


# --------------------------------------------
# Data Pre-Processing
# --------------------------------------------

# Remove the first column
concrete <- concrete[-1]
str(concrete)


# Rename the output variables
library(tidyverse)
concrete <- concrete %>% 
  rename(Coarse.Aggr = Coarse.Aggr.,
         Fine.Aggr = Fine.Aggr.,
         Slump = SLUMP.cm.,
         Flow = FLOW.cm.,
         Strength = Compressive.Strength..28.day..Mpa.) %>% 
  as_tibble()

# Display the data
concrete


# Subset data for each output variables
slump.data <- concrete %>% 
  select(-Flow, -Strength)

flow.data <- concrete %>% 
  select(-Slump, -Strength)

strength.data <- concrete %>% 
  select(-Slump, -Flow)

# Display slump.data
slump.data


# --------------------------------------------
# Linear Regression Modeling 
# --------------------------------------------

# Build the linear regression model for each output on all variables
slump.lm    <- lm(Slump ~., data = slump.data)
flow.lm     <- lm(Flow ~., data = flow.data)
strength.lm <- lm(Strength ~., data = strength.data)

# Extract adjusted R^2 with summary function
summary(slump.lm)
summary(flow.lm)
summary(strength.lm)

# --------------------------------------------
# Variable Selection with regsubsets
# --------------------------------------------

# Load the library
library(leaps)

# Run the regsubsets
slump.subsets    <- regsubsets(Slump ~ ., data = slump.data)
flow.subsets     <- regsubsets(Flow ~ ., data = flow.data)
strength.subsets <- regsubsets(Strength ~ ., data = strength.data)

# Use the summary() to find the relevant variables
slump.summary <- summary(slump.subsets)
slump.summary$which[which.min(slump.summary$bic), ]

flow.summary <- summary(flow.subsets)
flow.summary$which[which.min(flow.summary$bic), ]

strength.summary <- summary(strength.subsets)
strength.summary$which[which.min(strength.summary$bic), ]

# Re-run the linear regression model using only the specified variables from above
slump.lm2    <- lm(Slump ~ Slag + Water, data = slump.data)
flow.lm2     <- lm(Flow ~ Slag + Water, data = flow.data)
strength.lm2 <- lm(Strength ~ Cement + Fly.ash + Water + Coarse.Aggr + Fine.Aggr, data = strength.data) 

# Check the summary() for the detailed information
summary(slump.lm2)
summary(flow.lm2)
summary(strength.lm2)

# ---- Graph ----
# Find max
which.max(strength.summary$adjr2)
which.min(strength.summary$bic)

# Compare method
par(mfrow = c(1, 2))
plot(strength.summary$bic, ylab = "BIC", xlab = "Number of Variables", type = "l")
points(5, strength.summary$bic[5], col = "red", cex = 2, pch = 20)
plot(strength.summary$adjr2, ylab = "Adjusted Rsq", xlab = "Number of Variables", type = "l")
points(6, strength.summary$adjr2[6], col = "red", cex = 2, pch = 20)
title(main = "Comparison between BIC and Adjusted R-Sqr for Strength", outer = TRUE, line = -3)


# Plot bic 
par(mfrow = c(1,1))
plot(strength.subsets, scale = "bic", main = "Strength Linear Model")


# --------------------------------------------
# Variable Selection with step
# --------------------------------------------

# Variable selection with step()
slump.lm3 <- lm(Slump ~ 1, data = slump.data)
slump.step <- step(slump.lm3, 
                   ~Cement + Slag + Fly.ash + Water + SP + Coarse.Aggr + Fine.Aggr, 
                   trace = FALSE )

flow.lm3 <- lm(Flow ~ 1, data = flow.data)
flow.step <- step(flow.lm3, 
                   ~Cement + Slag + Fly.ash + Water + SP + Coarse.Aggr + Fine.Aggr, 
                   trace = FALSE )

strength.lm3 <- lm(Strength ~ 1, data = strength.data)
strength.step <- step(strength.lm3, 
                   ~Cement + Slag + Fly.ash + Water + SP + Coarse.Aggr + Fine.Aggr, 
                   trace = FALSE )

# Check the summary() for the detailed information
summary(slump.step)
summary(flow.step)
summary(strength.step)


# --------------------------------------------
# Extra
# --------------------------------------------

# Data for Residual plot
slump.plot <- tibble(slump.resid = residuals(slump.lm), slump.fit = fitted(slump.lm))
strength.plot <- tibble(strength.resid = residuals(strength.lm), strength.fit = fitted(strength.lm))


# Residual plot
slump.plot %>% 
  ggplot(aes(slump.fit, slump.resid)) +
  geom_point() +
  geom_smooth(color = "red") +
  ggtitle("Residual Plot of Slump") +
  labs(x = "Fitted Values", y = "Residuals") +
  theme(panel.background = element_rect(fill = "White"),
        plot.title = element_text(size = 17, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.line = element_line())


strength.plot %>% 
  ggplot(aes(strength.fit, strength.resid)) +
  geom_point() +
  geom_smooth(color = "red") +
  ggtitle("Residual Plot of Strength") +
  labs(x = "Fitted Values", y = "Residuals") +
  theme(panel.background = element_rect(fill = "White"),
        plot.title = element_text(size = 17, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.line = element_line())





