# Open Group Project ADEC7900.Rproj from the repository root first.
library(readr)
library(dplyr)

# Load merged dataset
gas <- read_csv("data/Massachusetts_January_Combined.csv", show_col_types = FALSE) %>%
  rename(
    Gas = Gas_usage_MMcf,
    HDD = `Jan HDD (base 65°F)`,
    ENSO = `ENSO Phase`
  )

# Summary KPIs by ENSO Phase
enso_kpis <- gas %>%
  group_by(ENSO) %>%
  summarise(
    Years = n(),
    Mean_Gas_MMcf = mean(Gas),
    SD_Gas_MMcf = sd(Gas),
    Median_Gas_MMcf = median(Gas),
    Mean_HDD = mean(HDD),
    .groups = "drop"
  )

print(enso_kpis)

# Model 1: Unadjusted January gas demand by ENSO phase
m_unadjusted <- lm(Gas ~ ENSO, data = gas)
print(summary(m_unadjusted))

# Model 2: Temperature-controlled January gas demand (ENSO + HDD)
m_controlled <- lm(Gas ~ HDD + ENSO, data = gas)
print(summary(m_controlled))

# Collect each model's results into a table
extract_results <- function(model, label) {
  s <- summary(model)
  coefficients <- as.data.frame(s$coefficients)
  intervals <- confint(model)
  
  data.frame(
    Model = label,
    Term = rownames(coefficients),
    coefficients,
    R_squared = s$r.squared,
    Adj_R_squared = s$adj.r.squared,
    CI95_Lower = intervals[, 1],
    CI95_Upper = intervals[, 2],
    row.names = NULL,
    check.names = FALSE
  )
}

# Combine the two models
model_results <- bind_rows(
  extract_results(m_unadjusted, "Model 1: Gas ~ ENSO"),
  extract_results(m_controlled, "Model 2: Gas ~ HDD + ENSO")
)


# Export the summary KPIs and regression models to CSV
write_excel_csv(enso_kpis, "data/ENSO_Summary_KPIs.csv")
write_excel_csv(model_results, "data/ENSO_Model_Results.csv")

