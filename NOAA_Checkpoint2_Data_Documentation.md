# NOAA Weather Data — Checkpoint 2 Documentation

**Course:** ADEC 7900 Software Tools  
**Team:** Group 2 — Natural Gas Consumption and Winter Weather  
**Prepared by:** Yiting Pei  
**Coverage:** Massachusetts, January 2015–2025 (11 annual January observations)

## Purpose

This dataset supports the team’s analysis of the relationship between Massachusetts winter weather and residential natural gas consumption. Weather records are matched to the EIA January gas-consumption series using `Year`.

## Data sources and preparation

- **Temperature:** NOAA Climate at a Glance, Massachusetts January average temperature (°F). Original CSV export: `data(3).csv` (local upload filename; rename clearly before adding to the repository).
- **Heating degree days:** NOAA Climate at a Glance, Massachusetts January heating degree days, base 65°F. Original CSV export: `heating degree data(1).csv`.
- **ENSO:** NOAA historical Relative Oceanic Niño Index (RONI), December–January–February (DJF) season, transcribed from a NOAA table screenshot used in the original project workbook. The ENSO phase labels are carried over from that workbook; the screenshot and transcription should be retained or independently verified for provenance.
- **Prepared weather data:** `NOAA_Massachusetts_January_2015_2025(2).csv` and `.xlsx` are two versions of the same January weather dataset. The workbook additionally contains source values and provenance notes.

Source URLs recorded in the workbook:

- NOAA Climate at a Glance: https://www.ncei.noaa.gov/access/monitoring/climate-at-a-glance/statewide/time-series
- NOAA RONI: https://www.cpc.ncep.noaa.gov/products/analysis_monitoring/enso/roni/

The temperature and HDD CSVs each contain dates in `YYYYMM` format. We selected the January rows for 2015–2025, joined them by date/year, and combined them with the supplied DJF RONI values and ENSO classifications. **The 11 temperature and HDD observations in the prepared CSV exactly match the corresponding values in both raw uploads.**

## Variable definitions

| Field | Meaning | Unit / categories |
|---|---|---|
| `Year` | Calendar year of January observation | 2015–2025 |
| `Month` | Observation month | January |
| `State` | Geographic coverage | Massachusetts |
| `Avg_Temp_F` | January average temperature | °F |
| `Jan_HDD_Base65F` | January heating degree days relative to a 65°F base | Degree-days |
| `DJF_RONI` | Relative Oceanic Niño Index for Dec–Jan–Feb centered on January | Index value |
| `ENSO_Phase` | ENSO classification in the supplied NOAA workbook | El Niño / La Niña / Neutral |

HDD is a measure of heating demand related to cold weather. Higher HDD values generally indicate greater heating needs; it is not a direct measure of natural gas use.

## Data quality checks

- 11 January observations, one for each year 2015–2025.
- No duplicate years in the prepared CSV.
- No missing values in the prepared CSV.
- All January temperature and HDD values match the two raw CSV files.
- The merged team dataset additionally contains EIA residential natural gas use (`Gas_usage_MMcf`), but this is not a NOAA field.

## Notes for Checkpoint 2

The existing Checkpoint 1 repository already contains the prepared NOAA `.xlsx` workbook, the EIA workbook, and a merged CSV. Avoid uploading another duplicate workbook unless it changes the analysis. If raw CSVs are added, give them descriptive names and document their purpose. A new NOAA analysis script can use the existing merged CSV and create **new** figures without overwriting Anh’s three Checkpoint 1 charts.

**Limitations:** Only January is represented, with 11 observations. ENSO phases are unevenly represented (4 El Niño, 6 La Niña, 1 Neutral). Any association is descriptive and does not prove causation. The ENSO values and phase labels were not independently re-downloaded during this check.
