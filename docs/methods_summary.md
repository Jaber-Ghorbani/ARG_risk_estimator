# Methods Summary

## Purpose

The ARG Risk & Abundance-Informed Index Tool is designed to support relative prioritization of antimicrobial resistance genes (ARGs) and ARG-containing samples. The tool combines gene-level hazard scores with user-provided abundance values to generate interpretable, user-specific outputs.

The tool is intended for research, screening, communication, and demonstration. It is not intended to provide a direct clinical infection-risk estimate, regulatory threshold, diagnostic result, or exposure-dose estimate.

## Conceptual Workflow

The app follows this main workflow:

```text
ARG abundance × ARG hazard score = abundance-informed index
```

At the gene level:

```text
ARG contribution = Abundance × Final ARG hazard score
```

At the sample level:

```text
Sample-level abundance-informed index = sum(ARG contribution)
```

The sample-level index is only meaningful for comparison when samples were analyzed with the same abundance unit, normalization approach, and analytical workflow.

## Final ARG Hazard Score

The final ARG hazard score is a relative prioritization metric scaled between 0 and 1. Higher values indicate greater relative priority based on the combined scoring criteria.

The score integrates four major components:

1. Clinical relevance / clinical importance
2. Mobility
3. Pathogenic potential
4. Inter-environment transmissibility

The conceptual weighted formula is:

```text
Final hazard score =
0.284 × Clinical relevance
+ 0.256 × Mobility
+ 0.248 × Pathogenic potential
+ 0.212 × Inter-environment transmissibility
```

The component weights reflect the relative importance assigned to the scoring criteria in the underlying research framework.

## Score Components

### Clinical relevance / clinical importance

Clinical relevance reflects the importance of the antimicrobial class associated with a given ARG. ARGs linked to antimicrobial classes of greater clinical importance receive higher clinical-relevance scores.

This component helps prioritize genes associated with resistance to antimicrobials that are more important for human or veterinary medicine.

### Mobility

Mobility reflects the potential association of an ARG with mobile genetic elements or horizontal gene transfer. ARGs with stronger mobility evidence receive higher mobility scores.

This component is important because mobile ARGs may have greater potential to disseminate across organisms or environments.

### Pathogenic potential

Pathogenic potential reflects the association of an ARG with pathogenic or clinically relevant bacterial hosts. ARGs more frequently associated with higher-priority pathogenic hosts receive higher pathogenic-potential scores.

This component does not mean that detection of the ARG alone confirms the presence of a pathogen. It is a relative prioritization signal.

### Inter-environment transmissibility

Inter-environment transmissibility reflects the potential occurrence or transfer relevance of an ARG across environmental and host-associated contexts, including human-associated, host-associated, man-made, and natural environments.

This component helps account for ARGs that may be more relevant across One Health pathways.

## Component Contributions

Component contributions are the weighted contributions of each score component to the final hazard score. For example:

```text
Clinical contribution = Clinical relevance score × Clinical weight
```

Component contributions help users understand which criteria are driving the final hazard score for a matched ARG.

## Criteria Completeness

Criteria completeness indicates whether all required scoring components were available for a given ARG.

A complete score generally means the ARG had available information for all four major criteria. An incomplete score means one or more component values may be unavailable or imputed according to project-specific scoring rules.

Users should interpret scores with incomplete criteria more cautiously.

## Final HC Score Percent

The final HC score percent is a percentage-scale representation of the final ARG hazard score.

```text
Final HC score percent = Final HC score × 100
```

This value is provided for easier interpretation and communication. It does not change the underlying ranking logic.

## Abundance-Informed Index

The abundance-informed index combines the user-provided abundance of each ARG with the final hazard score for that ARG.

For each matched gene:

```text
ARG contribution = Abundance × Final ARG hazard score
```

For each sample:

```text
Abundance-informed index = sum(ARG contributions across matched ARGs)
```

This index gives more influence to genes that are both more abundant and higher-scoring.

## Interpretation of the Index

A higher abundance-informed index indicates a higher combined burden of ARG abundance and relative hazard score among matched ARGs.

However, the index should only be compared across samples when the abundance data are directly comparable. For example, all samples should use the same unit, such as copies/mL, copies/g, reads per million, relative abundance, or another consistent normalization method.

Comparing indices across different abundance units or normalization methods can produce misleading conclusions.

## Matched and Unmatched ARGs

The tool matches user-entered ARG names against an internal server-side score table. Users see only the matched results relevant to their own query or uploaded dataset.

Unmatched ARGs are reported separately. An unmatched result does not mean that the ARG is low-risk or unimportant. It means the ARG could not be matched to the internal score table using the current matching rules.

Unmatched ARGs should be reviewed manually, especially if they are abundant or biologically important.

## Public Data Policy

The public repository contains app code, documentation, templates, and small example files.

The full internal ARG score database is not publicly released at this stage.

The app should not:

- show the full internal score database,
- allow download of the full internal score database,
- expose the master workbook,
- expose validation files, data dictionary files, or schema files unless explicitly approved,
- use full internal data as public examples.

The internal score table should be loaded from a private server-side path during deployment.

## Recommended Reporting Language

When reporting results, use language such as:

> The abundance-informed index provides a relative prioritization measure that combines ARG abundance with gene-level hazard score. It should be interpreted comparatively among samples analyzed with the same abundance unit and normalization method.

Avoid language implying that the index is a direct human-health risk estimate, infection probability, diagnostic conclusion, or regulatory threshold.
