# Frequently Asked Questions

## What does this tool do?

The ARG Risk & Abundance-Informed Index Tool helps users prioritize antimicrobial resistance genes (ARGs) using research-derived hazard scores. Users can enter ARG names or upload ARG abundance data, and the app returns matched scores, contribution estimates, sample-level indices, and unmatched ARG warnings.

## What is the final ARG hazard score?

The final ARG hazard score is a relative prioritization metric. It summarizes multiple hazard-related criteria into a single score that can help rank ARGs for research interpretation.

It is not a direct clinical infection-risk estimate, regulatory threshold, or diagnostic result.

## What score components are used?

The current framework uses four main components:

- clinical relevance,
- mobility,
- pathogenic potential,
- inter-environment transmissibility.

The conceptual weighted formula is:

```text
Final hazard score =
0.284 x Clinical relevance
+ 0.256 x Mobility
+ 0.248 x Pathogenic potential
+ 0.212 x Inter-environment transmissibility
```

## What is the abundance-informed index?

The abundance-informed index combines ARG abundance with ARG hazard score.

At the ARG level:

```text
ARG contribution = ARG abundance x final ARG hazard score
```

At the sample level:

```text
Sample-level abundance-informed index = sum(ARG contributions)
```

This index helps identify samples where high-abundance ARGs also have higher relative hazard scores.

## Can I compare index values across different studies?

Only with caution. Index values should generally be compared among samples analyzed using the same abundance unit, laboratory method, normalization strategy, and data-processing workflow.

For example, values reported as copies/mL should not be directly compared with values reported as copies/g, RPKM, RPM, relative abundance, or percent abundance unless an appropriate normalization strategy is used.

## What columns are required for uploaded datasets?

The minimal upload format is:

```csv
SampleID,ARG,Abundance
```

The extended format is:

```csv
SampleID,ARG,Abundance,Unit,Matrix,Location,Date,Notes
```

Only `SampleID`, `ARG`, and `Abundance` are required.

## What happens if an ARG is unmatched?

Unmatched ARGs are reported separately. An unmatched ARG should not be interpreted as low-risk or unimportant. It only means the submitted ARG name did not match the current internal score database or the app's name-normalization rules.

Users should review unmatched names for spelling differences, aliases, gene-family notation, or assay-specific labels.

## Will users be able to download the full score database?

No. The full internal ARG score database is not publicly released in this repository or through the app interface at this stage.

Users should only be able to download:

- their own matched lookup results,
- their own uploaded-data outputs,
- sample-level index results,
- unmatched ARG reports,
- templates,
- small example files.

## Why is the full score database private?

The public repository is intended to share the software structure, documentation, templates, and demonstration workflow while preventing premature release of the full internal score database and master workbook.

The app should load the score database from a protected server-side location during deployment.

## Can this be hosted on GitHub Pages?

Not as a standard Shiny app. GitHub Pages is mainly for static websites. This tool requires server-side R/Shiny logic to perform matching, validation, and private database handling.

Recommended deployment options include shinyapps.io, Posit Connect Cloud, institutional Shiny Server, or a similar server-side Shiny host.

## Does the tool perform exposure assessment?

Not yet. A future version may include exposure-assessment parameters to estimate exposure-informed ARG priority across environmental pathways. The current release focuses on hazard-score lookup and abundance-informed sample indexing.

## How should results be reported?

Recommended wording:

> ARGs were prioritized using a relative hazard-score framework that integrates clinical relevance, mobility, pathogenic potential, and inter-environment transmissibility. When abundance data were available, gene-level contributions were calculated as abundance multiplied by final hazard score, and sample-level abundance-informed indices were calculated as the sum of gene-level contributions.

Also report the abundance unit and normalization method used.

## Who developed this project?

Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, University of Nebraska-Lincoln.

Advisor: Dr. Bing Wang.
