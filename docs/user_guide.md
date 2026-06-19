# User Guide

## ARG Risk & Abundance-Informed Index Tool

This guide explains how to use the planned Shiny application for antimicrobial resistance gene (ARG) hazard-score lookup and abundance-informed sample indexing.

The tool is designed for research, teaching, demonstration, and preliminary prioritization. It is not a diagnostic or regulatory decision system.

---

## 1. What the tool does

The tool allows users to:

- enter one ARG or a list of ARG names,
- upload an ARG abundance dataset,
- match ARGs to an internal server-side hazard-score table,
- calculate gene-level ARG contributions,
- calculate sample-level abundance-informed indices,
- identify the top ARG contributors in each sample,
- flag unmatched ARGs,
- download user-specific outputs.

The central workflow is:

```text
ARG abundance × ARG hazard score = abundance-informed index
```

---

## 2. Main app tabs

### Home

The Home page introduces the tool, scientific purpose, and workflow.

Use this page to orient new users before they run an analysis.

### ARG Score Lookup

Use this tab when you want to check hazard scores for one or more ARGs.

Recommended input:

```text
sul1
tetM
blaTEM
ermB
qnrS
```

The app should return only the ARGs that match the internal score table. It should also report any unmatched names.

### Upload Dataset

Use this tab when you have abundance data from qPCR, metagenomics, or another ARG detection workflow.

The required columns are:

```text
SampleID,ARG,Abundance
```

The app checks that:

- all required columns are present,
- abundance values are numeric,
- abundance values are non-negative,
- ARG names can be normalized for matching.

### Example Analysis

This tab runs a small demonstration dataset so users can understand the workflow without uploading their own data.

The example dataset must remain small and must not expose the full internal score database.

### Template Download

This tab provides downloadable CSV templates.

Minimal template:

```text
SampleID,ARG,Abundance
```

Extended template:

```text
SampleID,ARG,Abundance,Unit,Matrix,Location,Date,Notes
```

### Methods / Score Meaning

This tab explains what the score components mean and how the final score should be interpreted.

### Results Interpretation

This tab explains how to interpret matched ARGs, unmatched ARGs, abundance-informed indices, and top contributors.

### Exposure Assessment — Coming Soon

This placeholder tab explains that a future version may include exposure-assessment parameters.

### Visitor Map & Stats

This tab or footer area may include visitor statistics. Visitor analytics must remain separate from ARG queries and uploaded datasets.

---

## 3. Upload file format

### Minimal format

```csv
SampleID,ARG,Abundance
Sample_1,sul1,1200
Sample_1,tetM,450
Sample_2,blaTEM,85
```

### Extended format

```csv
SampleID,ARG,Abundance,Unit,Matrix,Location,Date,Notes
Sample_1,sul1,1200,copies/mL,Surface water,Site A,2026-06-01,Example row
Sample_1,tetM,450,copies/mL,Surface water,Site A,2026-06-01,Example row
Sample_2,blaTEM,85,copies/mL,Wastewater,Site B,2026-06-02,Example row
```

The app should accept extra columns, but calculations should require only `SampleID`, `ARG`, and `Abundance`.

---

## 4. How matching works

ARG names should be normalized before matching. Normalization may include:

- trimming spaces,
- converting to lowercase,
- removing unnecessary punctuation,
- standardizing common ARG naming variants.

The app should use the normalized ARG-name column in the private score table when available.

Users should review unmatched ARGs carefully. An unmatched ARG is not necessarily low priority; it may be absent from the current internal scoring table or may use a naming format that requires manual review.

---

## 5. Calculations

### Gene-level contribution

```text
ARG contribution = Abundance × Final ARG hazard score
```

### Sample-level abundance-informed index

```text
Sample-level abundance-informed index = sum(ARG contribution)
```

This index represents the combined abundance and relative hazard-score burden of matched ARGs within a sample.

---

## 6. Interpreting results

### Individual ARG score

Higher final ARG hazard scores indicate higher relative priority based on the combined scoring framework.

The score is relative. It should not be interpreted as a direct probability of infection or clinical outcome.

### Sample-level index

A higher sample-level abundance-informed index indicates that a sample has a higher combined burden of matched ARG abundance and hazard score.

Only compare samples analyzed using the same abundance unit and normalization method.

### Top contributing ARGs

Top contributors are ARGs that drive the sample-level index. A gene may become a top contributor because it has:

- high abundance,
- high hazard score,
- or both.

### Unmatched ARGs

Unmatched ARGs should be reported separately. They should not be silently discarded.

Unmatched ARGs may represent:

- naming mismatches,
- ARGs not currently included in the internal score table,
- new or rare ARGs,
- formatting issues in the uploaded file.

---

## 7. Privacy and data-release rule

The full internal ARG score database should remain private at this stage.

The public app should only show:

- matched results from user-entered ARGs,
- matched results from user-uploaded datasets,
- sample-level analysis outputs,
- top contributors,
- unmatched warnings,
- templates,
- small example files.

The app should not provide a full-database preview or full-database download.

---

## 8. Recommended user workflow

1. Download the minimal or extended template.
2. Add sample IDs, ARG names, and abundance values.
3. Upload the file to the app.
4. Review validation messages.
5. Review matched and unmatched ARGs.
6. Examine the sample-level abundance-informed index.
7. Review top contributing ARGs.
8. Download user-specific results.

---

## 9. Interpretation caution

The final ARG hazard score is a relative prioritization metric. It is not a direct clinical infection-risk estimate, regulatory threshold, or diagnostic result.

The abundance-informed index should only be compared across samples analyzed with the same abundance unit and normalization method.

---

## 10. Contact

Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, University of Nebraska–Lincoln.

Advisor: Dr. Bing Wang.
