# Open Group Project ADEC7900.Rproj from the repository root first.
# Run once if needed:
install.packages(c("readxl", "dplyr","readr"))

library(readxl)
library(dplyr)

# Select NOAA_Massachusetts_January_2015_2025.xlsx
noaa <- read_excel(
  "data/NOAA_Massachusetts_January_2015_2025.xlsx",
  sheet = "NOAA Combined Data",
  skip = 4
)

# Select Natural Gas EIA Data.xlsx
gas <- read_excel(
  "data/Natural Gas EIA Data.xlsx",
  sheet = "Data 1",
  skip = 2
)

# Keep January 2015–2025 and create matching year column
gas_january <- gas %>%
  transmute(
    Year = as.integer(format(Date, "%Y")),
    Month_number = as.integer(format(Date, "%m")),
    Gas_usage_MMcf = .[[2]]
  ) %>%
  filter(
    Month_number == 1,
    Year >= 2015,
    Year <= 2025
  ) %>%
  select(Year, Gas_usage_MMcf)

# Merge the datasets by year
combined <- noaa %>%
  left_join(gas_january, by = "Year") %>%
  arrange(Year)

# Check the result
stopifnot(
  nrow(combined) == 11,
  !anyDuplicated(combined$Year),
  !anyNA(combined$Gas_usage_MMcf)
)

View(combined)

# Export a CSV that opens in Excel
readr::write_excel_csv(
  combined,
  "data/Massachusetts_January_Combined.csv"
)

# Show where the CSV was saved
getwd()