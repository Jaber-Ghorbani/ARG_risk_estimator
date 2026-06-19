# Developer Notes

These notes are for future maintainers of the ARG Risk & Abundance-Informed Index Tool.

## Purpose

This repository contains the public code, documentation, examples, and tests for a Shiny application that supports:

1. ARG hazard-score lookup;
2. user-uploaded abundance-table analysis;
3. abundance-informed index calculation;
4. visualization of top ARG contributors;
5. export of user-generated analysis outputs.

## Public/private data boundary

The repository is public. Do not commit the full ARG score database, master workbook, validation files, or schema/data-dictionary files.

Private files should stay outside GitHub, normally under a server-side path such as:

```text
data_private/arg_scores_clean.csv
```

The app should read the private database through an environment variable when deployed:

```r
Sys.getenv("ARG_SCORE_DB_PATH", "data_private/arg_scores_clean.csv")
```

The public demo score table is synthetic and is only used so the app can run without the private database.

## Core calculation

The app uses the final ARG hazard score as a relative prioritization metric:

```text
Final ARG hazard score =
0.284 * Clinical relevance +
0.256 * Mobility +
0.248 * Pathogenic potential +
0.212 * Inter-environment transmissibility
```

For uploaded abundance data, the abundance-informed contribution is:

```text
ARG contribution = Abundance * final ARG hazard score
```

The sample-level abundance-informed index is the sum of matched ARG contributions within each sample.

## Important interpretation rule

The final hazard score and abundance-informed index are relative prioritization outputs. They are not direct clinical infection-risk estimates, regulatory thresholds, or diagnostic results.

Sample-level index values should only be compared among samples analyzed with the same abundance unit and normalization method.

## Expected input columns

User-uploaded abundance files should contain at least:

```text
SampleID, ARG, Abundance
```

Optional metadata columns may include:

```text
Unit, Matrix, Location, Date, Notes
```

## Matching logic

ARG names are matched after normalization. The helper functions in `R/input_validation.R` and `R/score_lookup.R` should be used consistently across lookup, uploaded-data analysis, tests, and future features.

## Output policy

The app may export user-generated results, including matched lookup results, sample-level index tables, ARG contribution tables, and unmatched ARG lists.

The app should not provide a full database download or full public table view of the private score database.

## Test structure

Tests are stored under `tests/testthat/` and cover:

- input validation;
- score lookup;
- index calculation;
- output-table preparation.

Run tests locally with:

```r
testthat::test_dir("tests/testthat")
```

The GitHub Actions workflow under `.github/workflows/r-tests.yml` is intended to run these checks on push and pull request events.

## Development notes

When adding new features:

1. keep private data out of the repository;
2. update the documentation if interpretation changes;
3. add tests for new matching or calculation behavior;
4. keep download outputs limited to user-generated analysis results;
5. avoid changing the hazard-score formula unless the manuscript/model specification changes.
