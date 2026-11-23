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