# Security and Data Handling

## Public repository boundary

This repository should contain only public-safe materials:

- app code,
- helper scripts,
- documentation,
- templates,
- synthetic examples.

Do not commit full private score tables, master workbooks, user-uploaded datasets, or deployment secrets.

## Private score table

The full score table should be provided to the deployed app through a protected server-side path, such as an environment variable:

```text
ARG_SCORE_DB_PATH=/secure/path/to/arg_scores_clean.csv
```

## User-uploaded files

User-uploaded files should be processed during the app session and should not be written into the public repository.

## Reporting concerns

For repository or deployment concerns, open a GitHub issue using a synthetic example. Do not include private project data or user datasets in public reports.
