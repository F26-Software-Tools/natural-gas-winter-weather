# EIA Checkpoint 2 Data Documentation

## Purpose

Measures monthly Massachusetts January natural gas consumption (`2015–2025`) to compare winter heating demand across El Niño, La Niña, and Neutral years.

## Data Source
* **Source Agency:** U.S. Energy Information Administration (EIA) — *Natural Gas Consumption by End Use*
* **Raw File:** `Natural Gas EIA Data.xlsx` (sheet: `Data 1`)
* **Processing Script:** `MergedData.R`
* **Merged Dataset Output:** `data/Massachusetts_January_Combined.csv`
* **Geographic Coverage:** Massachusetts
* **Temporal Coverage:** January (`Month_number == 1`) from `2015` through `2025` ($n = 11$ annual observations)

---

## Variable Definitions

| Field | Meaning | Units |
| :--- | :--- | :--- |
| `Year` | Calendar year of January observation | 2015-2025 |
| `Month_number` | Observation month from the EIA date column and filtered to `1` (January). | Integer (`1`) |
| `Gas_usage_MMcf` | Monthly Massachusetts January natural gas consumption. | Million Cubic Feet (MMcf) |
| `Gas_per_HDD` | January gas used per heating degree day (`Gas_usage_MMcf / Jan HDD (base 65°F)`), measuring heating demand adjusted for coldness. | MMcf per HDD |

---

## Data Preparation & Quality Checks
1. **Extraction & Filtering (`MergedData.R`):** Extracted Year and Month_number from the dates, joined with the NOAA climate dataset on Year into `data/Massachusetts_January_Combined.csv`.
2. **Dataset Merge:** Joined the filtered EIA January records to the NOAA January temperature and ENSO dataset (`NOAA_Jan_Temp_and_ENSO_2015_2025.csv`) on `Year` to produce `data/Massachusetts_January_Combined.csv`.
3. **Audit Checks:**
   * Verified `11` January observations (`2015–2025`).
   * Confirmed no duplicates.
   * Confirmed no missing values.

---

## Limitations & Notes

The 11-year sample (`2015–2025`) limits statistical power across ENSO subgroups, and monthly totals do not reflect the daily extreme swings that can occur.
