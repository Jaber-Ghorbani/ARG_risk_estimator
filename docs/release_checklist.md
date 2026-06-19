# Release Checklist

This checklist is for preparing the ARG Risk & Abundance-Informed Index Tool for a public release.

## 1. Repository safety

- Confirm that no full ARG score table is committed.
- Confirm that no master Excel workbook is committed.
- Confirm that `data_private/` is listed in `.gitignore`.
- Confirm that public example files are synthetic or template-only.
- Confirm that no user-uploaded datasets are stored in the repository.

## 2. App functionality

- Run the app locally.
- Confirm that the app starts in demo mode when the private database is absent.
- Confirm that the app uses the private database only from the configured local or server path.
- Confirm that ARG lookup works for matched and unmatched entries.
- Confirm that dataset upload validation catches missing columns, blank values, non-numeric abundance values, and negative abundance values.
- Confirm that sample-level index calculations use abundance multiplied by the final ARG hazard score.
- Confirm that downloads only include user-generated outputs, templates, or synthetic examples.

## 3. Interpretation controls

- Confirm that the app states the score is a relative prioritization metric.
- Confirm that the app does not describe the score as a diagnostic result, clinical infection-risk estimate, or regulatory threshold.
- Confirm that the app warns users not to compare abundance-informed indices across incompatible abundance units or normalization methods.
- Confirm that unmatched ARGs are reported clearly and excluded from index calculations.

## 4. Documentation

- Review `README.md`.
- Review `docs/user_guide.md`.
- Review `docs/methods_summary.md`.
- Review `docs/score_interpretation.md`.
- Review `docs/deployment_notes.md`.
- Review `docs/developer_notes.md`.
- Confirm that citation instructions are marked as pending until the manuscript or preferred citation is finalized.

## 5. Testing

- Run `testthat` tests locally.
- Confirm that GitHub Actions passes.
- Confirm that helper functions load without depending on the private database.
- Confirm that the demo score table is sufficient for public test runs.

## 6. Deployment preparation

- Select the hosting target, such as shinyapps.io, Posit Connect, or a university server.
- Configure the private score-table path outside GitHub.
- Set the `ARG_SCORE_DB_PATH` environment variable on the hosting platform.
- Test the deployed app in demo mode first.
- Test the deployed app with the private score table after server configuration.
- Confirm that analytics are privacy-preserving and do not collect uploaded ARG datasets.

## 7. Public-release review

- Check all public tabs for wording, spelling, and interpretation consistency.
- Verify that the tool title and subtitle are consistent across the app and README.
- Confirm that the footer identifies the developer, lab, university, and advisor.
- Confirm that the repository license status is accurate.
- Tag the first release only after the app, tests, and documentation are stable.

## 8. Post-release maintenance

- Track issues and feature requests through GitHub Issues.
- Document score-database updates in a changelog.
- Re-run validation before replacing the private score table.
- Re-test the app after dependency updates.
- Keep public examples synthetic and small.
