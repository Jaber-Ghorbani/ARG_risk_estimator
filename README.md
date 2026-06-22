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

<p align="center">
  <a href="https://YOUR-SHINY-ACCOUNT.shinyapps.io/ARG_risk_estimator/"><strong>Launch the Shiny app</strong></a>
</p>

<p align="center">
  <em>Replace <code>YOUR-SHINY-ACCOUNT</code> with the active shinyapps.io account after deployment.</em>
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

## Run locally in R or RStudio

The app must be run from the repository root folder, which is the folder that contains `app.R`.

If you see this error:

```text
Error in shinyAppDir():
! App dir must contain either app.R or server.R.
```

it means R is not currently looking at the correct app folder, or your local copy does not include the latest `app.R` file.

### 1. Download or clone the repository

Option A: use Git from a terminal:

```bash
git clone https://github.com/Jaber-Ghorbani/ARG_risk_estimator.git
```

Option B: use GitHub Desktop:

1. Open GitHub Desktop.
2. Choose `File` → `Clone repository`.
3. Select `Jaber-Ghorbani/ARG_risk_estimator`.
4. Clone it to a local folder.

Option C: download the ZIP file from GitHub:

1. Open the GitHub repository page.
2. Click `Code` → `Download ZIP`.
3. Unzip the downloaded file.
4. Open the unzipped folder named something like `ARG_risk_estimator-main`.

### 2. Open the correct folder in RStudio

In RStudio, use:

```text
File → Open Project... or File → Open...
```

Open the folder that directly contains this file:

```text
app.R
```

Do **not** run the app from `Downloads`, `Desktop`, or a parent folder unless that folder directly contains `app.R`.

### 3. Confirm that R is in the correct folder

Run this in the R console:

```r
getwd()
list.files()
file.exists("app.R")
```

The final command must return:

```r
TRUE
```

If it returns `FALSE`, set the working directory to the folder that contains `app.R`.

Example for Windows:

```r
setwd("C:/Users/YOUR-NAME/Downloads/ARG_risk_estimator-main")
```

Example for Mac:

```r
setwd("/Users/YOUR-NAME/Downloads/ARG_risk_estimator-main")
```

Then check again:

```r
file.exists("app.R")
```

### 4. Install required R packages

Run this once:

```r
install.packages(c(
  "shiny",
  "bslib",
  "DT",
  "dplyr",
  "readr",
  "stringr",
  "tibble",
  "ggplot2",
  "rsconnect"
))
```

### 5. Run the app locally

After `file.exists("app.R")` returns `TRUE`, run:

```r
shiny::runApp(appDir = ".", launch.browser = TRUE)
```

Alternative: run the app by giving the full path:

```r
shiny::runApp("C:/Users/YOUR-NAME/Downloads/ARG_risk_estimator-main")
```

The app should open in your browser.

### 6. If the app opens but shows demo data

That is expected if the private score table is not present. For full local testing, place the private score table at:

```text
data_private/arg_scores_clean.csv
```

If that file is absent, the app falls back to the synthetic demo score table in `public_examples/demo_score_table.csv`.

---

## Deploy to shinyapps.io

Use these steps after the app runs locally without errors.

### 1. Create or log into a shinyapps.io account

Go to shinyapps.io and create an account or log in with an existing account.

Your shinyapps.io account name becomes part of the app URL:

```text
https://YOUR-SHINY-ACCOUNT.shinyapps.io/ARG_risk_estimator/
```

### 2. Install and load `rsconnect`

Run:

```r
install.packages("rsconnect")
library(rsconnect)
```

### 3. Connect RStudio/R to shinyapps.io

In the shinyapps.io dashboard:

1. Click your account/avatar menu.
2. Open `Tokens`.
3. Click `Show`.
4. Copy the full `rsconnect::setAccountInfo(...)` command.
5. Paste it into the R console and run it.

It will look like this:

```r
rsconnect::setAccountInfo(
  name = "YOUR-SHINY-ACCOUNT",
  token = "YOUR-TOKEN",
  secret = "YOUR-SECRET"
)
```

Do **not** paste your token or secret into GitHub, the README, `app.R`, or any public file.

### 4. Confirm the app still runs locally

Before deploying, run:

```r
file.exists("app.R")
shiny::runApp(appDir = ".", launch.browser = TRUE)
```

Stop the local app before deploying. In the R console, press:

```text
Esc
```

or click the red stop button in RStudio.

### 5. Deploy the app

From the same folder that contains `app.R`, run:

```r
rsconnect::deployApp(
  appDir = ".",
  appName = "ARG_risk_estimator",
  appTitle = "ARG Abundance-Informed HC Index Tool",
  launch.browser = TRUE
)
```

The first deployment may take several minutes because shinyapps.io needs to install the R package dependencies.

### 6. Copy the live app URL

After deployment, R will print and/or open the deployed app URL. It should look like:

```text
https://YOUR-SHINY-ACCOUNT.shinyapps.io/ARG_risk_estimator/
```

Copy that URL.

### 7. Update the README launch link

Replace the placeholder link near the top of this README:

```text
https://YOUR-SHINY-ACCOUNT.shinyapps.io/ARG_risk_estimator/
```

with the real deployed URL.

### 8. Redeploy after future edits

After making changes to `app.R`, helper scripts, or public example files, run:

```r
rsconnect::deployApp(appDir = ".")
```

Do not commit deployment tokens, secrets, or private score tables to GitHub.

---

## Common deployment errors

### Error: `App dir must contain either app.R or server.R`

Cause: R is not running from the app folder.

Fix:

```r
getwd()
list.files()
file.exists("app.R")
setwd("PATH/TO/ARG_risk_estimator-main")
shiny::runApp(appDir = ".")
```

### Error: package not found

Cause: one or more required packages are not installed locally.

Fix:

```r
install.packages(c("shiny", "bslib", "DT", "dplyr", "readr", "stringr", "tibble", "ggplot2", "rsconnect"))
```

### App deploys but uses demo scores

Cause: the private score table was not included in the deployment environment.

Fix for testing/prototype use: confirm that the app can run with the public demo score table.

Fix for full scoring use: deploy from a local environment where the private score table is available at:

```text
data_private/arg_scores_clean.csv
```

Do not commit this private file to GitHub.

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
