# Versioning Policy

This document defines the planned versioning approach for the ARG Risk & Abundance-Informed Index Tool.

## Purpose

Versioning is needed because the tool combines three elements that may change over time:

1. the Shiny application code,
2. the ARG score database used on the server, and
3. the public documentation explaining interpretation and limitations.

A version label should make clear which codebase, score-table release, and documentation set were used for a given analysis.

## Version format

Use semantic versioning for public releases:

```text
MAJOR.MINOR.PATCH
```

Examples:

```text
0.1.0
0.2.0
1.0.0
1.0.1
```

## Version meanings

### Major version

Increase the major version when changes substantially affect interpretation or comparability.

Examples:

- change in the final ARG hazard-score formula,
- change in criterion weights,
- change in score normalization strategy,
- major change in how matched ARGs are resolved,
- major expansion or restructuring of the private score database.

### Minor version

Increase the minor version when new functionality is added without changing the core interpretation framework.

Examples:

- new visualization tab,
- improved upload template,
- new summary outputs,
- new documentation section,
- new optional analytics dashboard,
- additional export format.

### Patch version

Increase the patch version for corrections that do not change scientific interpretation.

Examples:

- typo corrections,
- small UI fixes,
- bug fixes in table formatting,
- improved warning messages,
- non-substantive documentation edits.

## Pre-release stage

Until manuscript review and database release decisions are finalized, use version labels beginning with `0.`.

Suggested early sequence:

```text
0.1.0  Public scaffold and demo mode
0.2.0  Internal private-database deployment test
0.3.0  Beta version for collaborator review
1.0.0  First citable public release
```

## Database versioning

The private score table should have its own internal database version, separate from the public app version.

Recommended format:

```text
ARG-HC-YYYY-MM-DD
```

Example:

```text
ARG-HC-2026-06-19
```

The app should report the active score-table version in the interface when the private database is loaded. In demo mode, it should clearly state that synthetic data are being used.

## Documentation versioning

Documentation should be updated whenever the interpretation, limitations, or data policy changes.

For public releases, the README, user guide, methods summary, known limitations, and deployment notes should all be checked before assigning a release tag.

## GitHub releases

For each stable public release:

1. update `CHANGELOG.md`,
2. confirm tests pass,
3. confirm no private data are committed,
4. create a GitHub release tag,
5. archive the release if a manuscript or report cites the tool.

Suggested tag format:

```text
v0.1.0
v1.0.0
```

## Citation guidance

When the tool becomes citable, users should cite both:

1. the tool version, and
2. the related manuscript or methods paper, when available.

Until then, the repository should state that citation information will be added after manuscript finalization.

## Non-release commits

Routine development commits do not require a new formal version number. A version number is needed only when a stable state is being shared, deployed, cited, or used for a defined analysis.
