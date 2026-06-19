# Analytics Plan

This document outlines a future analytics approach for the ARG Risk & Abundance-Informed Index Tool.

## Purpose

The analytics system should help answer basic outreach and engagement questions:

- How many people visit the tool?
- Which pages or tabs are used most often?
- Which countries or regions are represented among visitors?
- How often are example files downloaded?
- How often do users run lookup or dataset-index workflows?

The analytics should support project reporting, conference impact summaries, and future tool improvement.

## Recommended analytics levels

### Level 1: Basic website traffic

Track standard, aggregate website metrics:

- total visits
- unique visitors
- approximate location by country or region
- referral source
- device type
- date and time of visit

This level is useful for public reporting such as: "The tool was accessed by users from X countries."

### Level 2: Tool-use events

Track non-sensitive app events:

- ARG lookup submitted
- dataset uploaded
- example dataset loaded
- result table exported
- methods page viewed
- documentation link opened

Do not record the actual ARG list, uploaded dataset content, SampleID values, abundance values, or any user-provided file content.

### Level 3: Aggregated research-use summaries

For future versions, the app may store only aggregate counts, such as:

- number of lookup queries per day
- number of dataset-index analyses per day
- number of matched versus unmatched ARGs per analysis, stored only as counts
- number of rows in uploaded datasets, stored only as a row count

This should be optional and should not store uploaded data.

## Visitor map

A public visitor map can be useful for outreach and impact reporting. The map should use approximate geographic information only, such as country-level or region-level location.

Recommended display fields:

- country or region
- number of visits
- first visit date
- most recent visit date

Avoid displaying exact city-level data if it could identify individual users.

## Data that should not be collected

The following should not be stored for routine analytics:

- uploaded files
- raw abundance values
- SampleID values
- complete ARG lists from user datasets
- user names
- email addresses
- IP addresses in user-facing reports
- full browser fingerprints
- any clinical, diagnostic, or patient-related data

## Possible implementation options

### Option A: Hosting-platform analytics

Use analytics already provided by the Shiny hosting platform. This is the simplest option and may be enough for early deployment.

### Option B: Plausible, Fathom, or similar privacy-focused analytics

Use a lightweight privacy-focused analytics service to collect aggregate traffic statistics without detailed user tracking.

### Option C: Custom Shiny event logging

Add a small server-side logging function for aggregate events only. This can write event counts to a simple database or log file.

Recommended event fields:

```text
session_date,event_type,event_count
2026-06-19,lookup_submitted,1
2026-06-19,dataset_uploaded,1
2026-06-19,results_exported,1
```

Do not include uploaded content or user-entered ARG names in the event log.

## Suggested event names

```text
app_opened
lookup_submitted
lookup_results_viewed
dataset_uploaded
example_dataset_loaded
sample_index_calculated
results_exported
methods_viewed
about_viewed
```

## Reporting metrics

Useful metrics for manuscript supplements, grant reporting, or conference summaries:

- total app sessions
- number of countries or regions represented
- number of ARG lookup analyses
- number of dataset-index analyses
- number of example-template downloads
- number of documentation views
- proportion of analyses with unmatched ARGs, reported only as aggregate percentage

## Recommended dashboard

A future admin-only dashboard could include:

- total visits
- visits by month
- visits by country or region
- number of lookup events
- number of dataset-index events
- number of exported result files
- number of unmatched-ARG warning events

The dashboard should not expose user-uploaded data.

## Implementation priority

1. Start with basic hosting-platform analytics.
2. Add a visitor map only after deployment is stable.
3. Add event-level tracking only if it is needed for project reporting.
4. Keep all analytics aggregate and non-identifying.

## Suggested public wording

> This tool may collect aggregate, non-identifying usage statistics, such as page visits and general geographic region, to evaluate outreach and improve functionality. Uploaded datasets are processed for analysis and are not intended to be stored for routine analytics.

