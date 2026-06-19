# AGENTS.md

## Project

This repository contains an R Shiny application for antimicrobial resistance gene hazard scoring and abundance-informed sample indexing.

Suggested public title:

**ARG Risk & Abundance-Informed Index Tool**

Suggested subtitle:

**A research-based platform for prioritizing antimicrobial resistance genes across environmental and One Health datasets.**

Suggested tagline:

**From ARG detection to risk-informed prioritization.**

## Main scientific purpose

The tool allows users to:

- enter ARG names,
- upload ARG abundance datasets,
- retrieve matched ARG hazard scores,
- calculate abundance-informed sample indices,
- identify top contributing ARGs,
- review unmatched ARG warnings,
- download their own analysis outputs.

## Critical private-data rule

The full internal ARG score database must not be publicly exposed.

Do not:

- print the full score database in the app,
- create a full-database table view,
- create a full-database download button,
- include the full score database in public examples,
- commit the full score database to the public GitHub repository,
- commit the original master Excel workbook,
- commit validation files, schema files, or data dictionary files unless explicitly approved later.

The private score database should be loaded from a private server-side path such as:

```text
data_private/arg_scores_clean.csv
