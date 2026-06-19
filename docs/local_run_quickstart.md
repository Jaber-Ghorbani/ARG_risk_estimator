# Local Run Quickstart

## 1. Clone the repository

```bash
git clone https://github.com/Jaber-Ghorbani/ARG_risk_estimator.git
cd ARG_risk_estimator
```

## 2. Install R packages

```r
install.packages(c(
  "shiny", "bslib", "DT", "dplyr", "readr", "stringr",
  "tidyr", "tibble", "ggplot2", "scales", "plotly", "testthat"
))
```

## 3. Run in demo mode

```r
shiny::runApp()
```

When the private score table is absent, the app uses the synthetic demo score table.

## 4. Run with private score table

Place the private table outside public Git tracking. For local testing, use:

```text
data_private/arg_scores_clean.csv
```

Or set an environment variable before launching the app:

```r
Sys.setenv(ARG_SCORE_DB_PATH = "path/to/private/arg_scores_clean.csv")
shiny::runApp()
```

## 5. Run tests

```r
testthat::test_dir("tests/testthat")
```

## 6. Confirm data boundary

Before pushing changes, verify that no private data files are staged:

```bash
git status
```
