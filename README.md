# Natural Gas Consumption and Winter Weather

**Course:** ADEC7900 Software Tools  
**Team:** Team 2  
**Project:** Checkpoint 1  
**Branch:** `Team_2Checkpoint_1.0`

## Project Overview

Our project explores how natural gas consumption relates to winter weather, including El Niño, La Niña, and heating degree days (HDD).

Our research question is: **How does residential natural gas consumption differ between El Niño and La Niña winters, and how is it related to heating degree days?**

Our decision makers are energy companies planning for winter demand. For Checkpoint 1, we examine Massachusetts in January from 2015 through 2025. This gives us an initial winter case study with 11 observations.

## Progress on the Eight Major Tasks

| Major task | Work completed for Checkpoint 1 |
| --- | --- |
| 1. Research topic | Selected the topic, defined the research question, and identified energy companies as the decision makers. |
| 2. GitHub setup and collaboration | Established the repository and required checkpoint branch, arranged team write access, and shared working files through GitHub. |
| 3. Combining data sources | Combined EIA natural gas consumption data with the NOAA weather workbook using the year as the matching field. |
| 4. Data visualization | Created and uploaded three R charts covering gas use by year, HDD versus gas use, and gas use by ENSO phase. |
| 5. Summary statistics | Calculated observation counts, average and minimum/maximum gas use, average HDD, group averages, and the HDD-gas correlation. Results and calculation code appear below. |
| 6. Project checkpoints | Prepared this Checkpoint 1 Markdown document and the supporting files on `Team_2Checkpoint_1.0`. The checkpoint provides the starting point for Checkpoint 2. |
| 7. Video presentation | Defined a five-minute presentation outline covering the business question, data and methods, findings, and limitations. The outline appears below. |
| 8. Final Markdown report | Defined the final report structure: Introduction, Data Summary, Data Analytics, Conclusion, and Policy Recommendation. This checkpoint supplies the initial data description and analysis. |

The video outline and final report structure document preparation for the later project deliverables.

## Data Sources and Coverage

| Source | Information used | Included file |
| --- | --- | --- |
| U.S. Energy Information Administration (EIA) | Massachusetts residential natural gas consumption, measured in million cubic feet (MMcf). | [Natural Gas EIA Data.xlsx](Group%20Project%20ADEC7900/Natural%20Gas%20EIA%20Data.xlsx) |
| NOAA weather workbook | January average temperature, January HDD with a 65°F base, DJF RONI, and ENSO phase labels. | [NOAA_Massachusetts_January_2015_2025.xlsx](Group%20Project%20ADEC7900/NOAA_Massachusetts_January_2015_2025.xlsx) |

The gas consumption values match the January 2015–2025 values in the [EIA Massachusetts residential consumption series](https://www.eia.gov/dnav/ng/hist/n3010ma2m.htm).

The merged dataset contains one row for each January from 2015 through 2025. ENSO labels come from the supplied NOAA workbook and are preserved during the merge.

### Combining and Checking the Data

The [merge script](Group%20Project%20ADEC7900/MergedData.R):

1. Reads the EIA and NOAA Excel files.
2. Selects January EIA observations from 2015 through 2025.
3. Creates a year field and joins the EIA observations to the NOAA workbook by year.
4. Sorts the combined data by year.
5. Checks for 11 rows, duplicate years, and missing gas consumption values.
6. Exports [Massachusetts_January_Combined.csv](Group%20Project%20ADEC7900/Massachusetts_January_Combined.csv).

The merged CSV has **11 observations, no duplicate years, and no missing values in any column**. These checks assess the merged file's completeness.

## Summary Statistics

| Measure | Result |
| --- | ---: |
| January observations | 11 |
| Average January residential gas consumption (MMcf) | 22,823.09 |
| Lowest January residential gas consumption (MMcf), 2023 | 18,905 |
| Highest January residential gas consumption (MMcf), 2022 | 26,339 |
| Average January HDD, base 65°F | 1,114.45 |
| Correlation between January HDD and gas consumption | 0.915 |

| ENSO phase | Number of years | Average gas consumption (MMcf) | Average January HDD |
| --- | ---: | ---: | ---: |
| El Niño | 4 | 23,007.25 | 1,154.25 |
| La Niña | 6 | 23,105.83 | 1,108.83 |
| Neutral | 1 | 20,390.00 | 989.00 |

All statistics above use the 11 observations in the merged CSV.

## Initial Visualizations and Findings

The [visualization script](Group%20Project%20ADEC7900/Initial_Visualizations.R) creates the following three images.

### 1. January Gas Use by Year

![January gas use in Massachusetts, 2015–2025](images/01_january_gas_by_year.png)

January residential gas consumption varies across years. The highest value is 26,339 MMcf in 2022, and the lowest is 18,905 MMcf in 2023.

### 2. January Heating Needs and Gas Use

![January HDD and residential gas use](images/02_january_hdd_and_gas.png)

Higher HDD values generally go with higher gas consumption. The correlation is approximately 0.915. This shows a strong positive association within this sample. It does not establish causation.

### 3. January Gas Use by ENSO Phase

![January residential gas use by ENSO phase](images/03_january_gas_by_enso.png)

Average gas consumption is similar for El Niño and La Niña years, and the individual observations overlap. This sample does not show a clear separation between these two groups. Only one Neutral year is available.

## Scope and Limitations

- The analysis covers Massachusetts residential gas consumption in January.
- The 11 observations do not represent all winter months or all natural gas use.
- ENSO groups have different sizes, with only one Neutral observation.
- The analysis describes historical patterns and associations. It is not a demand forecast.
- The NOAA weather values and ENSO classifications are taken from the supplied workbook.

## Team Contributions

| Team member | Contribution |
| --- | --- |
| Garrett Barnachez | Collected EIA natural gas data and uploaded the combined dataset, merge script, and working project files. |
| Yiting Pei | Collected and supplied the NOAA weather data used in the merged dataset. |
| Anh Bui | Set up the GitHub repository and checkpoint branch, arranged team access, organized the shared work, and created and uploaded the three initial R visualizations. |

The summary statistics and findings in this README document the team's Checkpoint 1 analysis.

## GitHub Collaboration

### Successes

- Established the repository under the F26-Software-Tools course organization.
- Created and published the required branch, `Team_2Checkpoint_1.0`.
- Arranged write access for Project Team 2 and invited teammates.
- Shared the source datasets, merged CSV, R project, and analysis scripts.
- Used GitHub Desktop to fetch shared work, commit local changes, and push files.
- Uploaded all three chart images to the `images` folder.

### Challenges and What We Learned

Access to the course GitHub organization initially delayed setup. We resolved the access issue and connected GitHub Desktop to the class account.

Shared files appeared on `main`, which required us to check the selected branch and synchronize our local repository. We confirmed that the checkpoint branch included the shared data.

This process helped us understand the difference between local files, commits, branches, and pushes. Checking the branch before working and pushing completed changes made collaboration easier.

## How to Run the Analysis

1. Clone or download the repository and select `Team_2Checkpoint_1.0`.
2. Open `Group Project ADEC7900/Group Project ADEC7900.Rproj` in RStudio.
3. Install the packages below once if needed:

```r
install.packages(c("readxl", "readr", "dplyr", "ggplot2"))
```

4. Open `MergedData.R` and click **Source** to recreate the merged CSV from the Excel files.
5. Open `Initial_Visualizations.R` and click **Source** to recreate the three charts.
6. The image files save to the repository's `images` folder, one level above the RStudio project folder.
7. Run the following code in the RStudio Console to reproduce the summary statistics:

```r
library(readr)
library(dplyr)

gas <- read_csv("Massachusetts_January_Combined.csv", show_col_types = FALSE) %>%
  rename(Gas = Gas_usage_MMcf,
         HDD = `Jan HDD (base 65°F)`,
         ENSO = `ENSO Phase`)

gas %>%
  summarise(Years = n(),
            Average_gas = round(mean(Gas), 2),
            Minimum_gas = min(Gas),
            Maximum_gas = max(Gas),
            Average_HDD = round(mean(HDD), 2),
            HDD_gas_correlation = round(cor(HDD, Gas), 3))

gas %>%
  group_by(ENSO) %>%
  summarise(Years = n(),
            Average_gas = round(mean(Gas), 2),
            Average_HDD = round(mean(HDD), 2))
```

All input datasets and analysis scripts are included in the repository. The summary code uses the same merged CSV as the three visualizations.

## Video Presentation Outline

The five-minute presentation is structured as follows:

- **Minute 1:** Business context, decision maker, and research question.
- **Minute 2:** Data sources, January coverage, and merging method.
- **Minutes 3–4:** The three visualizations and main findings.
- **Minute 5:** Limitations and implications for further winter-demand analysis.

## Final Markdown Report Structure

The final report follows the required sections:

1. **Introduction:** Business context, decision maker, and research question.
2. **Data Summary:** Sources, coverage, variables, and descriptive statistics.
3. **Data Analytics:** Visualizations, comparisons, and supporting analysis.
4. **Conclusion:** Findings, limitations, and future work.
5. **Policy Recommendation:** A recommendation supported by the completed analysis, including benefits and risks.
