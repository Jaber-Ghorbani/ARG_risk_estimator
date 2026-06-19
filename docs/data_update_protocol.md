# Data Update Protocol

This protocol describes how to update the private score database without exposing it in the public repository.

## 1. Update the private source files locally

Keep the full score table, master workbook, validation summaries, and issue logs outside the public repository.

Recommended private path during local testing:

```text
data_private/arg_scores_clean.csv
```

## 2. Validate the score table before deployment

Before using a new score table, check:

- required ARG-name column is present,
- final score column is present,
- no final scores are outside 0 to 1,
- no duplicate normalized ARG names exist unless intentionally resolved,
- drug-class labels are reviewed for consistency,
- missing values are documented.

## 3. Run app tests

Run locally:

```r
testthat::test_dir("tests/testthat")
```

Then run the Shiny app:

```r
shiny::runApp()
```

## 4. Deploy privately

On the deployment server, set:

```text
ARG_SCORE_DB_PATH=/secure/path/to/arg_scores_clean.csv
```

The path should be readable by the app but not publicly downloadable.

## 5. Record the database version

Each private score-table update should be recorded with:

- database version,
- date,
- number of ARGs,
- number of complete records,
- validation notes,
- major scoring-method changes.

## 6. Do not commit private data

Before pushing to GitHub, confirm that these files are not staged:

```text
MasterExcel*.xlsx
arg_scores_clean*.csv
arg_scores_validation*.csv
arg_scores_data_dictionary*.csv
arg_scores_clean_schema*.csv
data_private/
```
