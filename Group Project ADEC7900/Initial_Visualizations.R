# Open Group Project ADEC7900.Rproj first.
# Save this script beside the merged CSV, then click Source.
# Run once in the Console if needed:
# install.packages(c("readr", "dplyr", "ggplot2"))

library(readr)
library(dplyr)
library(ggplot2)

# Read the data and shorten three column names.
gas <- read_csv("Massachusetts_January_Combined.csv", show_col_types = FALSE) %>%
  rename(Gas = Gas_usage_MMcf,
         HDD = `Jan HDD (base 65°F)`,
         ENSO = `ENSO Phase`)

# Basic checks and the HDD-gas correlation.
colSums(is.na(gas))
sum(duplicated(gas$Year))
table(gas$ENSO)
cor(gas$HDD, gas$Gas)

theme_set(theme_minimal())

# Chart 1: January gas use over time.
p1 <- ggplot(gas, aes(x = Year, y = Gas)) +
  geom_line(color = "steelblue") +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 2015:2025) +
  labs(title = "January Gas Use in Massachusetts, 2015-2025",
       x = "Year", y = "Reported gas use (MMcf)")

# Chart 2: heating degree days and gas use.
p2 <- ggplot(gas, aes(x = HDD, y = Gas, color = ENSO)) +
  geom_point(size = 3) +
  labs(title = "January Heating Needs and Gas Use",
       subtitle = "Massachusetts, 2015-2025",
       x = "January heating degree days (base 65°F)",
       y = "Reported gas use (MMcf)")

# Chart 3: compare individual years across ENSO phases.
p3 <- ggplot(gas, aes(x = ENSO, y = Gas, color = ENSO)) +
  geom_point(size = 3) +
  labs(title = "January Gas Use by ENSO Phase",
       subtitle = "Massachusetts, 2015-2025. Each point is one year.",
       x = "ENSO phase", y = "Reported gas use (MMcf)",
       caption = "El Niño: 4 years. La Niña: 6 years. Neutral: 1 year.")

print(p1)
print(p2)
print(p3)

# Save the charts in the repository's images folder.
dir.create("../images", showWarnings = FALSE)
ggsave("../images/01_january_gas_by_year.png", p1, width = 8, height = 5, dpi = 300)
ggsave("../images/02_january_hdd_and_gas.png", p2, width = 8, height = 5, dpi = 300)
ggsave("../images/03_january_gas_by_enso.png", p3, width = 8, height = 5, dpi = 300)

# Scope: January only. These charts show association, not causation.
# Confirm the gas-use sector and units against the original EIA workbook.
