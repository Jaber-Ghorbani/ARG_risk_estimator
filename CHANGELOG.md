# Changelog

All notable changes to the ARG Risk & Abundance-Informed Index Tool will be documented in this file.

This project follows a simple release-log structure:

- `Added` for new files, features, or documentation.
- `Changed` for revisions to existing functionality.
- `Fixed` for bug fixes or corrections.
- `Security / Privacy` for changes related to data protection and public-release safety.

## Unreleased

### Added

- Initial public repository structure for the ARG Risk & Abundance-Informed Index Tool.
- R Shiny application skeleton for ARG lookup and abundance-informed index calculation.
- Helper functions for input validation, ARG-score lookup, index calculation, plotting, and output preparation.
- Public example input templates and a synthetic demo score table.
- Documentation for methods, score interpretation, user guidance, deployment, analytics planning, developer notes, and release review.
- Unit-test structure using `testthat`.
- GitHub Actions workflow for automated R test execution.

### Security / Privacy

- Full ARG score database is intentionally excluded from the public repository.
- Private data are expected to remain outside GitHub under a local or deployment-specific private path.
- Public examples use synthetic data only.
- Full database download is intentionally not supported.

## 0.1.0 - Draft public scaffold

### Added

- Project README with scope, workflow, formula, app tabs, and interpretation warnings.
- Core method summary for the relative ARG hazard score and abundance-informed index.
- Public templates for user uploads.
- Preliminary Shiny interface structure.

### Notes

- This is a development scaffold, not a finalized public release.
- Real score-table deployment requires private server-side data configuration before release.
