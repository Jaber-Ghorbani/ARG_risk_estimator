# Privacy Notice

This project is designed so the public GitHub repository does not expose the full ARG score database or user-uploaded datasets.

## Repository privacy boundary

The public repository may include:

- Shiny app code,
- helper R scripts,
- documentation,
- templates,
- synthetic example datasets,
- synthetic example outputs,
- public-safe interface assets.

The public repository must not include:

- the full internal ARG score table,
- the original master Excel workbook,
- private validation files,
- private credentials,
- user-uploaded datasets,
- server logs containing user inputs.

## User-uploaded data

Uploaded CSV files are used only to calculate matched ARG results, gene-level contributions, and sample-level abundance-informed index values during the app session.

The app should not publish or redistribute user-uploaded datasets.

## Visitor analytics

Visitor analytics, if added later, should be separated from ARG queries and uploaded datasets. Do not send ARG names, abundance values, uploaded files, or calculated outputs to a third-party analytics provider.

## Public downloads

The app may provide downloads of:

- user-generated lookup results,
- user-generated sample-index outputs,
- user-generated gene-contribution outputs,
- unmatched ARG summaries,
- public templates,
- synthetic examples.

The app should not provide a full public database download unless the project team intentionally changes the release policy.
