# Troubleshooting Guide

## App opens in demo mode

Reason: the full private score table was not found by the running app.

Check:

1. The private table exists on the deployment server.
2. The environment variable `ARG_SCORE_DB_PATH` points to the private table.
3. The private table is not committed to GitHub.
4. The server account running the app has permission to read the file.

## Uploaded CSV is rejected

The uploaded file must include these columns exactly:

```text
SampleID
ARG
Abundance
```

Common problems:

- Misspelled column names.
- Blank sample IDs.
- Blank ARG names.
- Abundance stored as text instead of numbers.
- Negative abundance values.

## ARGs are unmatched

Unmatched does not mean low priority. It means the submitted ARG label did not match the internal score table after normalization.

Check for:

- spelling differences,
- allele naming differences,
- hyphen/underscore differences,
- family-level names versus gene-level names,
- assay target names that do not map directly to a scored ARG.

## Index values look very large

The abundance-informed index is scale-dependent. Large abundance units will generate large index values. Compare only samples with the same abundance unit and normalization method.

## Plots do not appear

Check that `ggplot2` is installed. Interactive plots require `plotly`, but static plots should work without it.

## Downloads are empty

Downloads are generated from the user's current lookup or uploaded analysis. Run the lookup or dataset index calculation before downloading.

## GitHub Actions tests fail

Check the failed job log. Most failures will come from missing package dependencies, changed function names, or test expectations that need to be updated after changing helper functions.
