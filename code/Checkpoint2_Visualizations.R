library(readr)
library(dplyr)
library(ggplot2)

# Read the regression results
results <- read_csv(
  "data/ENSO_Model_Results.csv",
  show_col_types = FALSE
)

# Keep ENSO comparisons. El Niño is the reference group.
effects <- results %>%
  filter(Term %in% c("ENSOLa Niña", "ENSONeutral")) %>%
  mutate(
    Comparison = if_else(
      Term == "ENSOLa Niña",
      "La Niña vs El Niño",
      "Neutral vs El Niño"
    ),
    Model = if_else(
      Model == "Model 1: Gas ~ ENSO",
      "ENSO only",
      "ENSO + HDD"
    )
  )

# Points show estimates. Lines show 95% confidence intervals.
p5 <- ggplot(
  effects,
  aes(x = Comparison, y = Estimate, color = Model)
) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed",
    color = "gray50"
  ) +
  geom_pointrange(
    aes(ymin = CI95_Lower, ymax = CI95_Upper),
    position = position_dodge(width = 0.5)
  ) +
  coord_flip() +
  scale_color_manual(
    values = c("ENSO only" = "#777777",
               "ENSO + HDD" = "#0072B2")
  ) +
  scale_y_continuous(labels = scales::label_comma()) +
  labs(
    title = "ENSO Differences Before and After HDD Adjustment",
    subtitle = "Massachusetts residential gas use, January 2015–2025",
    x = NULL,
    y = "Gas-use difference from El Niño (MMcf)",
    color = NULL,
    caption = paste(
      "Lines show 95% confidence intervals. Associations only.",
      "El Niño: 4 years. La Niña: 6 years. Neutral: 1 year.",
      sep = "\n"
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(hjust = 0)
  )

print(p5)

# Save the chart
dir.create("images", showWarnings = FALSE)

ggsave(
  "images/05_enso_model_comparison.png",
  p5,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)




# Excursion: compare three models
gas_compare <- read_csv(
  "data/Massachusetts_January_Combined.csv",
  show_col_types = FALSE
) %>%
  rename(
    Gas = Gas_usage_MMcf,
    HDD = `Jan HDD (base 65°F)`,
    ENSO = `ENSO Phase`
  )

# Set El Niño as the reference category
gas_compare$ENSO <- factor(
  gas_compare$ENSO,
  levels = c("El Niño", "La Niña", "Neutral")
)

models <- list(
  "ENSO only" = lm(Gas ~ ENSO, data = gas_compare),
  "HDD only" = lm(Gas ~ HDD, data = gas_compare),
  "ENSO + HDD" = lm(Gas ~ HDD + ENSO, data = gas_compare)
)

# Collect model-fit measures
fit_summary <- bind_rows(
  lapply(names(models), function(label) {
    model <- models[[label]]
    s <- summary(model)
    
    data.frame(
      Model = label,
      N = nobs(model),
      Parameters = length(coef(model)),
      R_squared = s$r.squared,
      Adj_R_squared = s$adj.r.squared,
      In_sample_RMSE_MMcf = sqrt(mean(residuals(model)^2))
    )
  })
)

print(fit_summary)

# Test whether adding ENSO improves the HDD-only model
enso_test <- anova(
  models[["HDD only"]],
  models[["ENSO + HDD"]]
)

print(enso_test)

# Save the comparison results
dir.create("outputs", showWarnings = FALSE)

write_csv(fit_summary, "outputs/model_fit_summary.csv")

write_csv(
  as.data.frame(enso_test),
  "outputs/hdd_enso_comparison.csv"
)












# Collect observed and fitted gas use
fitted_data <- bind_rows(
  lapply(names(models), function(label) {
    data.frame(
      Model = label,
      Year = gas_compare$Year,
      ENSO = gas_compare$ENSO,
      Observed = gas_compare$Gas,
      Fitted = as.numeric(fitted(models[[label]]))
    )
  })
)

# Keep the panels in the intended order
fitted_data$Model <- factor(
  fitted_data$Model,
  levels = names(models)
)

# Use the same axis limits for all models
plot_limits <- range(
  c(fitted_data$Observed, fitted_data$Fitted)
) + c(-800, 800)

p6 <- ggplot(
  fitted_data,
  aes(x = Observed, y = Fitted, color = ENSO)
) +
  geom_abline(
    intercept = 0,
    slope = 1,
    linetype = "dashed",
    color = "gray50"
  ) +
  geom_point(size = 3) +
  facet_wrap(~ Model, nrow = 1) +
  coord_equal(
    xlim = plot_limits,
    ylim = plot_limits
  ) +
  scale_x_continuous(
    labels = scales::label_comma(),
    n.breaks = 3
  ) +
  scale_y_continuous(
    labels = scales::label_comma(),
    n.breaks = 3
  ) +
  scale_color_manual(
    values = c(
      "El Niño" = "#D55E00",
      "La Niña" = "#0072B2",
      "Neutral" = "#666666"
    )
  ) +
  labs(
    title = "HDD Improves Fit Within This Sample",
    subtitle = "Massachusetts residential gas use, January 2015–2025",
    x = "Observed gas use (MMcf)",
    y = "Fitted gas use (MMcf)",
    color = "ENSO phase",
    caption = paste(
      "Dashed line: fitted value equals observed value.",
      "All models use the same 11 observations for fitting and evaluation.",
      "This chart does not measure forecast accuracy.",
      sep = "\n"
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(hjust = 0)
  )

print(p6)

ggsave(
  "images/06_observed_vs_fitted.png",
  p6,
  width = 12,
  height = 6,
  dpi = 300,
  bg = "white"
)

write_csv(
  fitted_data,
  "outputs/model_fitted_values.csv"
)

