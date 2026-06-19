# ARG Risk & Abundance-Informed Index Tool

<p align="center">
  <strong>A research-based platform for prioritizing antimicrobial resistance genes across environmental and One Health datasets.</strong>
</p>

<p align="center">
  <em>From ARG detection to risk-informed prioritization.</em>
</p>

<p align="center">
  <img alt="R Shiny" src="https://img.shields.io/badge/R-Shiny-blue">
  <img alt="Status" src="https://img.shields.io/badge/status-in%20development-orange">
  <img alt="Data policy" src="https://img.shields.io/badge/full%20score%20database-private-red">
  <img alt="Use" src="https://img.shields.io/badge/use-research%20prioritization-green">
</p>

---

## Quick Navigation

- [Purpose](#purpose)
- [What the Tool Does](#what-the-tool-does)
- [Scientific Workflow](#scientific-workflow)
- [Input Format](#input-format)
- [Public vs Private Data](#public-vs-private-data)
- [Planned App Tabs](#planned-app-tabs)
- [Repository Structure](#repository-structure)
- [Run Locally](#run-locally)
- [Deployment Plan](#deployment-plan)
- [Important Interpretation Note](#important-interpretation-note)
- [Development Team](#development-team)

---

## Purpose

The **ARG Risk & Abundance-Informed Index Tool** is an R Shiny application for antimicrobial resistance gene (ARG) hazard-score lookup and abundance-informed sample indexing.

The tool is designed for:

- research support,
- One Health and environmental AMR data interpretation,
- ARG prioritization,
- manuscript/tool demonstration,
- IAFP-style professional presentation,
- advisor and collaborator review.

The goal is to provide a polished interface where users can enter ARG names or upload ARG abundance datasets and receive interpretable, user-specific outputs without accessing the full internal score database.

---

## What the Tool Does

Users will be able to:

| Feature | Description |
|---|---|
| ARG score lookup | Enter one ARG or paste a list of ARGs and receive matched hazard-score results. |
| Dataset upload | Upload a CSV file containing sample IDs, ARG names, and abundance values. |
| ARG matching | Match uploaded ARGs against an internal server-side ARG score database. |
| Abundance-informed indexing | Calculate gene-level contributions and sample-level abundance-informed index values. |
| Top contributor analysis | Identify ARGs that contribute most strongly to sample-level index values. |
| Unmatched ARG reporting | Warn users when uploaded ARGs are not found in the internal database. |
| Downloadable outputs | Allow users to download their own matched results and analysis outputs. |
| Templates and examples | Provide small public example files and upload templates. |

---

## Scientific Workflow

The core workflow is:

```text
ARG abundance × ARG hazard score = abundance-informed index
```

At the gene level:

```text
ARG contribution = ARG abundance × final ARG hazard score
```

At the sample level:

```text
Sample-level abundance-informed index = sum(ARG contribution)
```

This allows users to move from ARG detection or abundance data toward risk-informed prioritization.

---

## Score Concept

The internal ARG hazard score integrates four major components:

| Component | Meaning |
|---|---|
| Clinical relevance / clinical importance | Relative clinical importance of the antimicrobial class associated with the ARG. |
| Mobility | Potential association with mobile genetic elements or horizontal gene transfer. |
| Pathogenic potential | Association with pathogenic or clinically relevant bacterial hosts. |
| Inter-environment transmissibility | Potential relevance across human, host-associated, man-made, and natural environments. |

Conceptual weighted formula:

```text
Final hazard score =
0.284 × Clinical relevance
+ 0.256 × Mobility
+ 0.248 × Pathogenic potential
+ 0.212 × Inter-environment transmissibility
```

---

## Input Format

### Minimal Template

```csv
SampleID,ARG,Abundance
Sample_1,sul1,1200
Sample_1,tetM,450
Sample_2,blaTEM,85
```

### Extended Template

```csv
SampleID,ARG,Abundance,Unit,Matrix,Location,Date,Notes
Sample_1,sul1,1200,copies/mL,Surface water,Site A,2026-06-01,Example row
Sample_1,tetM,450,copies/mL,Surface water,Site A,2026-06-01,Example row
Sample_2,blaTEM,85,copies/mL,Wastewater,Site B,2026-06-02,Example row
```

Required columns:

```text
SampleID
ARG
Abundance
```

Abundance values must be numeric and non-negative.

---

## Public vs Private Data

This repository is intended to contain the **public-safe app code**, documentation, templates, and small example files.

The full internal ARG score database is **not publicly released at this stage**.

### Public-safe content

The public repository may include:

- Shiny app code,
- helper R scripts,
- documentation,
- upload templates,
- small synthetic/demo example datasets,
- example outputs,
- CSS and interface assets.

### Private content

The following files should **not** be committed to the public repository:

- full ARG score database,
- original master Excel workbook,
- validation summary and validation issue files,
- data dictionary and schema files if not intentionally released,
- private deployment credentials,
- user-uploaded datasets.

Expected private score-database path during deployment:

```text
data_private/arg_scores_clean.csv
```

The `data_private/` folder should remain excluded by `.gitignore`.

---

## Planned App Tabs

| Tab | Purpose |
|---|---|
| Home | Project title, description, and workflow summary. |
| ARG Score Lookup | Paste ARG names and receive matched score results. |
| Upload Dataset | Upload abundance data and calculate sample-level index values. |
| Example Analysis | Run a small built-in example for demonstration. |
| Template Download | Download minimal and extended CSV templates. |
| Methods / Score Meaning | Explain score components, weights, completeness, and interpretation. |
| Results Interpretation | Explain matched/unmatched ARGs, index values, and top contributors. |
| Exposure Assessment — Coming Soon | Placeholder for future exposure-informed analysis. |
| Visitor Map & Stats | Optional visitor analytics placeholder, separated from query/upload data. |

---

## Repository Structure

```text
ARG_risk_estimator/
├── app.R
├── README.md
├── AGENTS.md
├── .gitignore
├── R/
│   ├── input_validation.R
│   ├── score_lookup.R
│   ├── index_calculation.R
│   ├── plots.R
│   └── report_download.R
├── public_examples/
│   ├── minimal_template.csv
│   ├── extended_template.csv
│   ├── example_dataset.csv
│   └── example_output.csv
├── docs/
│   ├── project_status.md
│   ├── score_interpretation.md
│   ├── user_guide.md
│   ├── methods_summary.md
│   └── faq.md
└── www/
    ├── custom.css
    └── workflow_figure_placeholder.txt
```

---

## Run Locally

Install required R packages:

```r
install.packages(c(
  "shiny",
  "bslib",
  "DT",
  "dplyr",
  "readr",
  "stringr",
  "tidyr",
  "ggplot2",
  "plotly",
  "rsconnect"
))
```

Then run:

```r
shiny::runApp()
```

For full local testing, the private score database should be placed at:

```text
data_private/arg_scores_clean.csv
```

or provided through a protected server-side environment path.

---

## Deployment Plan

The app is intended for server-side Shiny deployment through one of the following:

- shinyapps.io,
- Posit Connect Cloud,
- institutional Shiny Server,
- another protected R Shiny hosting environment.

A standard GitHub Pages site is not sufficient for the complete version because the app requires R server logic and private score-database handling.

---

## Visitor Map & Stats

A future deployment may include a visitor map or usage-statistics widget.

Privacy note:

> Visitor statistics are separate from ARG queries and uploaded datasets. Query inputs and uploaded ARG datasets should not be shared with the visitor-map provider.

---

## Important Interpretation Note

The final ARG hazard score is a **relative prioritization metric**.

It is **not**:

- a direct clinical infection-risk estimate,
- a regulatory threshold,
- a diagnostic result,
- a substitute for exposure assessment,
- a standalone prediction of human health outcome.

The abundance-informed index should only be compared across samples analyzed with the same abundance unit and normalization method.

Unmatched ARGs should not be interpreted as low-risk. They indicate that the uploaded ARG name was not matched to the internal score database and may require manual review, synonym checking, or future database expansion.

---

## Current Development Status

This repository is in active development.

Immediate priorities:

1. Build the Shiny app skeleton.
2. Add public-safe templates and examples.
3. Add input-validation functions.
4. Add ARG-name normalization and score lookup functions.
5. Add abundance-informed index calculations.
6. Add polished user-interface styling.
7. Test locally in RStudio.
8. Deploy through a protected Shiny host.

---

## Development Team

Developed by: 
Food Safety & Food Microbiology Lab  
Department of Food Science and Technology  
University of Nebraska–Lincoln

Contact:

**Dr. Bing Wang**

---

## Citation

Formal citation information will be added after manuscript/tool finalization.

Interim citation format:

```text
Ghorbani, J. ARG Risk & Abundance-Informed Index Tool. University of Nebraska–Lincoln.
```

---

## Data-Release Note

The public codebase is intended to support tool development and demonstration. The full internal ARG score database is not included in this repository. Public users should only access matched results from their own ARG queries or uploaded datasets.
