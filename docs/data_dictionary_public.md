# Public Data Dictionary

This document describes public-facing input and output fields used by the ARG Risk & Abundance-Informed Index Tool. It does not describe or release the full internal score database.

## Required upload fields

| Field | Type | Description |
|---|---:|---|
| `SampleID` | text | User-defined sample identifier. |
| `ARG` | text | Antimicrobial resistance gene name or target name. |
| `Abundance` | numeric | Non-negative abundance value. Units are user-defined and must be consistent across samples being compared. |

## Optional upload fields

| Field | Type | Description |
|---|---:|---|
| `Unit` | text | Abundance unit, such as copies/mL, copies/g, reads per million, or normalized copies. |
| `Matrix` | text | Sample matrix, such as wastewater, surface water, soil, manure, or food-production environment. |
| `Location` | text | Site or location label supplied by the user. |
| `Date` | date/text | Sampling date. |
| `Notes` | text | Optional user notes. |

## Lookup output fields

| Field | Description |
|---|---|
| `query_arg` | ARG name entered by the user. |
| `matched_status` | Matched or Unmatched. |
| `matched_arg_name` | Internal matched ARG name returned by the app. |
| `arg_family` | ARG family, where available. |
| `drug_class` | Drug class label, where available. |
| `final_hc_score` | Relative ARG hazard-characterization score on a 0 to 1 scale. |
| `final_hc_score_percent` | Same score expressed as a percentage. |
| `risk_category` | Qualitative relative-priority category. |
| `criteria_completeness` | Indicator of score-evidence completeness, where available. |
| `interpretation` | Plain-language interpretation. |

## Dataset-analysis output fields

| Field | Description |
|---|---|
| `ARG_contribution` | `Abundance × final_hc_score`. |
| `abundance_informed_index` | Sum of ARG contributions within a sample. |
| `matched_ARG_records` | Number of uploaded ARG records that matched the score database. |
| `unmatched_ARG_records` | Number of uploaded ARG records that did not match. |
| `unmatched_warning` | Warning text for samples with unmatched ARGs. |

## Interpretation limits

The final ARG hazard score is a relative prioritization metric. It is not a direct clinical infection-risk estimate, regulatory threshold, or diagnostic result. The abundance-informed index should only be compared among samples analyzed with the same abundance unit and normalization method.
