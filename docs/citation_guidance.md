# Citation Guidance

This document provides suggested citation language for users of the ARG Risk & Abundance-Informed Index Tool. Citation text should be updated once the associated manuscript, archived software release, or DOI is available.

## What users should cite

Users should cite the appropriate combination of the following, depending on how the tool was used:

1. The peer-reviewed methods paper, once published.
2. The specific software release or repository version used for analysis.
3. The ARG hazard-score database version used by the deployed app.
4. Any external ARG-abundance dataset uploaded by the user, if applicable.

## Suggested repository citation

Until a formal DOI is available, users may cite the repository as:

> Ghorbani, J. ARG Risk & Abundance-Informed Index Tool. GitHub repository: Jaber-Ghorbani/ARG_risk_estimator. Version: [version or commit SHA]. Accessed: [date].

## Suggested software-release citation

After a GitHub release or archived release is created, use:

> Ghorbani, J. ARG Risk & Abundance-Informed Index Tool. Version [version]. [Repository or archive DOI]. Accessed: [date].

## Suggested methods-paper citation

After manuscript publication, cite the paper describing the hazard-characterization framework and score construction:

> Ghorbani, J.; Wang, B.; [co-authors]. [Article title]. [Journal]. [Year]. [Volume]:[pages]. DOI: [DOI].

## Suggested in-text wording

For manuscript methods sections:

> ARGs were prioritized using the ARG Risk & Abundance-Informed Index Tool, which combines gene-level hazard characterization with user-provided ARG abundance. The gene-level ARG hazard score is a relative prioritization metric based on clinical relevance, mobility, pathogenic potential, and inter-environment transmissibility. Sample-level abundance-informed index values were calculated as the sum of abundance multiplied by ARG hazard score across matched ARGs.

For short reports:

> ARG prioritization was performed using the ARG Risk & Abundance-Informed Index Tool (version [version]).

## Required interpretation language

When reporting results, users should state that:

- The ARG hazard score is a relative prioritization metric.
- The score is not a direct clinical infection-risk estimate.
- The score is not a regulatory threshold or diagnostic result.
- Abundance-informed index values should only be compared among samples analyzed with the same abundance unit and normalization approach.
- Unmatched ARGs are excluded from calculated index values unless handled separately.

## Database-version reporting

A complete analysis report should include:

- Tool version.
- App deployment date or access date.
- ARG score database version.
- Number of uploaded ARG records.
- Number and percentage of matched ARG records.
- Number and percentage of unmatched ARG records.
- Abundance unit and normalization method.

## Example reporting sentence

> The analysis used ARG Risk & Abundance-Informed Index Tool version [version] with ARG score database version [database version]. Of [n] uploaded ARG records, [m] were matched to the score database and included in the abundance-informed index calculation. Index values are relative and should be interpreted only within datasets using the same abundance unit and normalization method.

## Notes for developers

Do not hard-code a final citation before publication or DOI assignment. The README, app About tab, and release notes should be updated together when a manuscript citation or software DOI becomes available.
