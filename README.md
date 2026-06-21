# ARG Abundance-Informed HC Index Tool

<p align="center">
  <strong>A simple Shiny app for comparing ARG abundance profiles using a hazard-characterization score.</strong>
</p>

<p align="center">
  <img alt="R Shiny" src="https://img.shields.io/badge/R-Shiny-blue">
  <img alt="Status" src="https://img.shields.io/badge/status-simple%20prototype-orange">
  <img alt="Data policy" src="https://img.shields.io/badge/full%20score%20database-private-red">
  <img alt="Output" src="https://img.shields.io/badge/output-abundance--informed%20HC%20index-green">
</p>

---

## What this tool does

This repository contains a public-safe R Shiny prototype for calculating an **abundance-informed HC index** from ARG abundance data.

The app does three things:

1. **Looks up ARG hazard-characterization scores** for entered ARG names.
2. **Calculates sample-level abundance-informed HC index values** from uploaded ARG abundance tables.
3. **Compares user samples with reference water-sample benchmarks** from the manuscript Figure 4 analysis.

The main calculation is:

```text
ARG contribution = ARG abundance × final HC score

Sample abundance-informed HC index = Σ(ARG contribution)
```

---

## Current simple app structure

The first release is intentionally narrow.

| App section | Purpose |
|---|---|
| Home | Short explanation of the tool and calculation. |
| ARG lookup | Paste ARG names and check matched scores. |
| Calculate index | Upload a CSV file or use the built-in example dataset. |
| Reference waters | View Figure 4-style benchmark values for hospital wastewater, wastewater, drinking water, lake water, river water, and sea water. |
| Methods | Concise explanation of the score, weights, matching, and interpretation limits. |

---

## Input format

Upload a CSV file with three required columns:

```csv
SampleID,ARG,Abundance
Sample_1,sul1,1200
Sample_1,tetM,450
Sample_2,blaTEM,85
```

Rules:

- `SampleID` identifies the sample.
- `ARG` is the ARG name.
- `Abundance` must be numeric and non-negative.
- Compare samples only when the same abundance unit and normalization method are used.

---

## Reference water comparison

The app includes a public-safe summary file:

```text
public_examples/figure4_water_benchmark.csv
```

This file contains environment-level benchmark values from the validation analysis. It does **not** expose the full ARG score database or the underlying validation dataset.

Reference groups currently included:

| Rank | Water group | Samples | Mean abundance-informed HC index |
|---:|---|---:|---:|
| 1 | Hospital wastewater | 15 | 829.300 |
| 2 | Wastewater treatment samples | 26 | 147.674 |
| 3 | Drinking water | 8 | 27.825 |
| 4 | Lake water | 11 | 9.308 |
| 5 | River water | 8 | 6.065 |
| 6 | Sea water | 25 | 0.683 |

---

## Public vs private data

This public repository can contain:

- Shiny app code,
- helper R scripts,
- public templates,
- synthetic demo data,
- summary-level Figure 4 benchmark values,
- documentation.

This public repository should **not** contain:

- the full ARG score database,
- the master Excel workbook,
- validation gene-level contribution files,
- private user-uploaded datasets,
- deployment credentials.

The deployed app can load the private score table from:

```text
data_private/arg_scores_clean.csv
```

or from the protected environment variable:

```text
ARG_SCORE_DB_PATH
```

The `.gitignore` file excludes private score tables, Excel workbooks, validation files, credentials, and generated outputs.

---

## Repository layout

```text
ARG_risk_estimator/
├── app.R
├── README.md
├── R/
│   ├── input_validation.R
│   ├── score_lookup.R
│   ├── index_calculation.R
│   ├── plots.R
│   └── report_download.R
├── public_examples/
│   ├── demo_score_table.csv
│   ├── example_dataset.csv
│   ├── minimal_template.csv
│   ├── extended_template.csv
│   └── figure4_water_benchmark.csv
├── www/
│   └── custom.css
└── data_private/
    └── arg_scores_clean.csv   # private, not committed
```

---

## Run locally

Install required R packages:

```r
install.packages(c(
  "shiny",
  "bslib",
  "DT",
  "dplyr",
  "readr",
  "stringr",
  "tibble",
  "ggplot2"
))
```

Then run:

```r
shiny::runApp()
```

For full local testing, place the private score table at:

```text
data_private/arg_scores_clean.csv
```

The app will fall back to a small synthetic demo score table when the private score table is not available.

---

## Interpretation note

The final HC score and abundance-informed HC index are **relative prioritization metrics**.

They are not:

- direct infection-risk estimates,
- regulatory thresholds,
- diagnostic results,
- predictions of clinical outcome.

Unmatched ARGs should not be interpreted as low-risk. They indicate that the uploaded ARG name did not match the current score table and may require synonym review or future database expansion.

---

## Development team

Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, Department of Food Science and Technology, University of Nebraska–Lincoln.

Advisor: Dr. Bing Wang

---

## Citation

Formal citation will be added after manuscript/tool finalization.
