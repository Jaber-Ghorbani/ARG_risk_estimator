# Score Interpretation Guide

This document provides user-facing guidance for interpreting ARG hazard scores and abundance-informed sample indices produced by the ARG Risk & Abundance-Informed Index Tool.

## 1. Individual ARG hazard score

The final ARG hazard score is a relative prioritization metric ranging from 0 to 1.

Higher values indicate that an ARG has a higher combined hazard profile based on the scoring criteria used in the underlying framework.

Lower values indicate a lower relative priority within the scoring framework, not the absence of concern.

The score should be interpreted as:

```text
higher score = higher relative priority for review, monitoring, or follow-up analysis
```

## 2. What the score is not

The final ARG hazard score is not:

- a direct clinical infection-risk estimate,
- a diagnostic result,
- a regulatory threshold,
- a prediction that disease will occur,
- a substitute for exposure assessment,
- a substitute for site-specific risk assessment.

The score helps rank and prioritize ARGs. It does not independently determine public-health risk.

## 3. Hazard-score components

The final score integrates four scientific dimensions:

| Component | Interpretation |
|---|---|
| Clinical relevance | Importance of the associated antimicrobial class for human or veterinary medicine. |
| Mobility | Potential association with mobile genetic elements or horizontal transfer. |
| Pathogenic potential | Association with pathogenic or clinically relevant bacterial hosts. |
| Inter-environment transmissibility | Relevance across human, host-associated, man-made, and natural environments. |

The conceptual weighted formula is:

```text
Final hazard score =
0.284 × Clinical relevance
+ 0.256 × Mobility
+ 0.248 × Pathogenic potential
+ 0.212 × Inter-environment transmissibility
```

## 4. Suggested qualitative categories

If the app displays qualitative categories, these categories should be interpreted as app-derived labels for communication and visualization.

A practical interpretation scheme is:

| Category | General meaning |
|---|---|
| Lower relative priority | ARGs with lower final hazard scores relative to the internal scoring distribution. |
| Moderate relative priority | ARGs with intermediate final hazard scores. |
| Higher relative priority | ARGs with higher final hazard scores and stronger combined component evidence. |
| Very high relative priority | ARGs near the upper end of the scoring distribution. |

If categories are derived from quantiles, they should be described as distribution-based categories rather than external risk thresholds.

## 5. Criteria completeness

Criteria completeness describes how many component criteria contributed to the final hazard score.

A complete record includes all four components:

- clinical relevance,
- mobility,
- pathogenic potential,
- inter-environment transmissibility.

An incomplete record means one or more components were unavailable, imputed, carried forward, or treated according to the project scoring rules.

Users should interpret incomplete records with additional caution.

## 6. Final HC score percent

If shown, the final HC score percent is a percent-scaled form of the final hazard score.

For example:

```text
Final HC score = 0.42
Final HC score percent = 42%
```

This percent value is for readability. It should not be interpreted as percent probability of infection, disease, transfer, or exposure.

## 7. Abundance-informed ARG contribution

When abundance data are provided, the app calculates a gene-level contribution:

```text
ARG contribution = ARG abundance × final ARG hazard score
```

A high contribution can occur because:

- the ARG is highly abundant,
- the ARG has a high hazard score,
- or both.

Top-contributor results help identify which ARGs drive the sample-level index.

## 8. Sample-level abundance-informed index

The sample-level abundance-informed index is calculated as:

```text
Sample-level abundance-informed index = sum(ARG contribution)
```

This index summarizes the combined abundance-weighted ARG hazard burden for a sample.

It is most useful for comparing samples analyzed with the same:

- abundance unit,
- sample-processing method,
- normalization method,
- sequencing or qPCR workflow,
- ARG detection threshold.

## 9. Comparing samples

Sample-level comparisons are appropriate only when abundance values are comparable.

For example, these comparisons are usually more defensible:

```text
copies/mL vs copies/mL
RPM vs RPM
copies/ng DNA vs copies/ng DNA
```

These comparisons may be misleading without normalization:

```text
copies/mL vs copies/g
raw read counts vs normalized reads
qPCR absolute abundance vs metagenomic relative abundance
```

## 10. Matched ARGs

A matched ARG is an uploaded or entered ARG name that the app successfully connects to the internal score database.

Matched results may include:

- ARG name,
- drug class,
- final hazard score,
- final HC score percent,
- criteria completeness,
- app-derived risk category,
- interpretation text.

Only matched user-query or uploaded-dataset results should be displayed.

## 11. Unmatched ARGs

An unmatched ARG is an ARG entered by the user that could not be matched to the internal score database.

Unmatched ARGs should not be interpreted as low-risk.

Possible reasons for unmatched ARGs include:

- spelling differences,
- naming-format differences,
- family-level names instead of gene-level names,
- newly described ARGs,
- ARGs outside the current internal database,
- database curation limitations.

The app should clearly report unmatched ARGs so users know which records were excluded from score-based calculations.

## 12. Recommended reporting language

When reporting results from this tool, use language such as:

> ARGs were prioritized using a relative hazard-score framework integrating clinical relevance, mobility, pathogenic potential, and inter-environment transmissibility. When abundance data were available, gene-level contributions were calculated as ARG abundance multiplied by the final ARG hazard score, and sample-level abundance-informed indices were calculated as the sum of ARG contributions within each sample.

When describing limitations, use language such as:

> The final hazard score is a relative prioritization metric and should not be interpreted as a direct clinical infection-risk estimate, regulatory threshold, or diagnostic result. Sample-level abundance-informed indices should only be compared across samples analyzed with comparable abundance units and normalization methods.

## 13. Future exposure assessment

The current version does not implement exposure assessment.

A future module may incorporate environmental pathway, contact, dose, persistence, and exposure-frequency parameters to support exposure-informed ARG prioritization.

Until that module is implemented, the current abundance-informed index should be interpreted as a screening and prioritization output, not a complete exposure-based risk estimate.
