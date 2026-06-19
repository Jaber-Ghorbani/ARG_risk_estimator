# Deployment Notes

This document summarizes the planned deployment approach for the ARG Risk & Abundance-Informed Index Tool.

## 1. Recommended deployment model

The app should be deployed as a Shiny application, not as a static GitHub Pages site.

GitHub Pages can host static HTML, CSS, and JavaScript, but it cannot run the R server logic required for:

- ARG score lookup
- uploaded dataset processing
- abundance-informed index calculation
- server-side score-table matching
- output generation

Recommended hosting options include:

- Posit Connect
- shinyapps.io
- an institutional Shiny Server
- another server that can run R and Shiny

## 2. Public repository contents

The public GitHub repository should include:

- Shiny source code
- helper R scripts
- documentation
- public templates
- synthetic example inputs
- synthetic example outputs
- small demonstration score data only

The public repository should not include the full score database or master workbook.

## 3. Private score table location

For deployment, place the full ARG score table on the application server outside the public repository, for example:

```text
data_private/arg_scores_clean.csv
```

The `.gitignore` file already excludes `data_private/` and score-table CSV patterns.

## 4. Environment-variable option

A flexible deployment option is to define an environment variable that points to the private score table:

```text
ARG_SCORE_DB_PATH=/secure/path/to/arg_scores_clean.csv
```

The app can then read the file path from the server environment. This allows the same public codebase to run with either:

- the full private score table in production, or
- a synthetic demo table when the private file is not available.

## 5. Demo mode

When the full score table is not available, the app should fall back to a tiny synthetic score table. Demo mode is useful for:

- public GitHub review
- screenshots
- early testing
- conference demonstrations before server deployment
- onboarding collaborators

Demo-mode results should be clearly labeled as demonstration-only outputs.

## 6. Data-update workflow

Recommended update workflow:

1. Validate the updated score table locally.
2. Check for missing values, duplicate ARG names, inconsistent labels, and values outside expected score ranges.
3. Save the approved score table in the private server directory.
4. Restart or redeploy the Shiny app.
5. Test single-ARG lookup and dataset-upload examples.
6. Confirm that full score-table download is not exposed.

## 7. User-upload handling

The app is designed for user-supplied input datasets with at least these columns:

```text
SampleID, ARG, Abundance
```

Optional metadata columns may include:

```text
Unit, Matrix, Location, Date, Notes
```

The app should return only derived outputs from the user's submitted data, such as matched ARGs, unmatched ARGs, gene-level contributions, and sample-level index values.

## 8. Visitor map and usage statistics

A visitor map or usage-statistics panel can be added later using a privacy-conscious analytics provider or server logs.

Recommended metrics:

- total visits
- country or region-level visitor map
- number of example downloads
- number of dataset analyses
- general browser/device statistics

Avoid collecting personally identifiable information unless a formal data-use notice is added.

## 9. Deployment checklist

Before public launch:

- Confirm app runs locally.
- Confirm all required R packages install cleanly.
- Confirm demo mode works without private data.
- Confirm production mode reads the private score table.
- Confirm no full database download is available.
- Confirm templates download correctly.
- Confirm sample output downloads correctly.
- Confirm documentation links work.
- Confirm visual layout works on laptop and mobile screens.

## 10. Suggested production label

A useful production label for the app header is:

```text
ARG Risk & Abundance-Informed Index Tool
From ARG detection to risk-informed prioritization.
```

A short footer can state:

```text
Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, University of Nebraska-Lincoln. Advisor: Dr. Bing Wang.
```
