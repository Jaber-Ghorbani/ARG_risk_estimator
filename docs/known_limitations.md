# Known Limitations

This document summarizes the main limitations users should understand before interpreting outputs from the ARG Risk & Abundance-Informed Index Tool.

## 1. The ARG hazard score is relative

The final ARG hazard score is a relative prioritization metric. It is designed to help compare ARGs within a consistent analytical framework. It is not a direct estimate of clinical infection risk, outbreak risk, treatment failure probability, or regulatory compliance status.

## 2. Scores depend on available evidence

Some ARGs have complete information across all four hazard components, while others have incomplete evidence. Missing component information can affect interpretability. Users should consider score completeness when comparing genes.

## 3. The abundance-informed index depends on the input unit

The abundance-informed index is calculated from user-provided abundance values and the ARG hazard score. Results should only be compared among samples generated with the same abundance unit, normalization method, sequencing or qPCR workflow, and preprocessing assumptions.

## 4. The tool does not replace exposure assessment

The current version prioritizes ARGs using hazard and abundance information. It does not yet model human exposure, dose-response, persistence, transport, host association, viability, or infection probability.

## 5. Unmatched ARGs are not zero-risk genes

If an uploaded ARG does not match the score database, the tool reports it as unmatched. This means the ARG was not scored in the current database or did not match by name. It should not be interpreted as low risk or no risk.

## 6. Gene-name harmonization remains challenging

ARG names can vary across databases, tools, nomenclature systems, and publications. The app applies basic normalization, but synonym mapping and family-level grouping may require additional curation.

## 7. The public repository uses synthetic demonstration data

Public example files are synthetic and are provided only to demonstrate file format and app behavior. The full ARG score database is intentionally kept private and should not be committed to GitHub.

## 8. Interpretation should remain context-specific

ARG prioritization should be interpreted alongside sample type, matrix, treatment process, geography, detection method, sequencing depth, qPCR normalization, and project-specific objectives.

## Recommended wording for reports

> The ARG hazard score and abundance-informed index are intended for relative prioritization of ARGs and samples. They should not be interpreted as clinical risk estimates, diagnostic outputs, or regulatory thresholds.
