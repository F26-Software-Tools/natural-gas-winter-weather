# NOAA Weather Analysis — ADEC 7900 Group 2, Checkpoint 2
# Author: Yiting Pei
# Run from the repository root (open Group Project ADEC7900.Rproj first).
# Requires the existing Checkpoint 1 merged CSV; does not overwrite prior charts.
# install.packages(c("readr", "dplyr", "ggplot2")) # Run once if needed

library(readr)
library(dplyr)
library(ggplot2)

weather <- read_csv("data/Massachusetts_January_Combined.csv", show_col_types = FALSE)
stopifnot(nrow(weather) == 11, !anyDuplicated(weather$Year))
stopifnot(!anyNA(weather[, c("Avg Temp (°F)", "Jan HDD (base 65°F)", "Gas_usage_MMcf")]))

weather <- weather %>%
  rename(Temp_F = `Avg Temp (°F)`, HDD = `Jan HDD (base 65°F)`,
         ENSO = `ENSO Phase`, Gas_MMcf = Gas_usage_MMcf)

# NOAA weather descriptive statistics (new material for Checkpoint 2).
weather_summary <- weather %>%
  summarise(Years = n(), Mean_Temp_F = mean(Temp_F),
            Min_Temp_F = min(Temp_F), Max_Temp_F = max(Temp_F),
            Mean_HDD = mean(HDD), Min_HDD = min(HDD), Max_HDD = max(HDD))
print(weather_summary)

# Compare January weather across ENSO groups (small group sizes: descriptive only).
enso_weather <- weather %>%
  group_by(ENSO) %>%
  summarise(Years = n(), Mean_Temp_F = mean(Temp_F),
            Mean_HDD = mean(HDD), .groups = "drop")
print(enso_weather)

# Associations with EIA gas use (not causal estimates).
cat("Temperature vs gas correlation:", cor(weather$Temp_F, weather$Gas_MMcf), "\n")
cat("HDD vs gas correlation:", cor(weather$HDD, weather$Gas_MMcf), "\n")

# New plot: January temperature vs residential gas use.
p_temp <- ggplot(weather, aes(x = Temp_F, y = Gas_MMcf)) +
  geom_point(color = "#2563EB", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "#64748B") +
  labs(title = "January Temperature and Residential Gas Use",
       subtitle = "Massachusetts, 2015–2025 (11 observations)",
       x = "January average temperature (°F)",
       y = "Residential gas consumption (MMcf)",
       caption = "Descriptive association; not evidence of causation") +
  theme_minimal()
print(p_temp)

dir.create("images", showWarnings = FALSE)
ggsave("images/04_january_temperature_vs_gas.png", p_temp,
       width = 8, height = 5, dpi = 300)

# Optional: keep the summary output reproducible for README integration.
dir.create("outputs", showWarnings = FALSE)
write_csv(weather_summary, "outputs/noaa_weather_summary.csv")
write_csv(enso_weather, "outputs/noaa_weather_by_enso.csv")
