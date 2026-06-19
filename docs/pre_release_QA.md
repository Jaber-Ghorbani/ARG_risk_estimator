# Pre-Release QA Checklist

Use this checklist before sharing the app with collaborators or deploying publicly.

## App startup

- App opens without error.
- Demo mode works without the private score table.
- Private-table mode works when `ARG_SCORE_DB_PATH` is configured.

## Lookup tab

- Single ARG lookup works.
- Multiple ARG lookup works.
- Matched and unmatched ARGs are shown clearly.
- Lookup results download correctly.

## Dataset Index tab

- Built-in example dataset runs.
- Valid uploaded CSV runs.
- Invalid CSV files show clear messages.
- Sample-level index table is generated.
- Gene-level contribution table is generated.
- Unmatched ARG table is generated.
- Download buttons produce CSV files.

## Interpretation language

- Relative score language is visible.
- Unit-dependence of the abundance-informed index is visible.
- Unmatched ARG warning is visible.
- The app purpose is described as research prioritization.

## Repository review

- No private score table is committed.
- No master workbook is committed.
- No user-uploaded dataset is committed.
- Public examples are synthetic or template files only.
- Documentation index is up to date.

## Testing

Run:

```r
testthat::test_dir("tests/testthat")
```

Then manually run:

```r
shiny::runApp()
```
