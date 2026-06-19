# Current Repository Status

This repository now contains a public-safe scaffold for the ARG Risk & Abundance-Informed Index Tool.

## Included

- R Shiny app skeleton in `app.R`.
- Input validation helpers.
- ARG score lookup helpers.
- Abundance-informed index calculation helpers.
- Plot helpers.
- Output download helpers.
- Public upload templates.
- Synthetic example dataset and demo score table.
- User, methods, deployment, analytics, maintenance, and troubleshooting documentation.
- GitHub Actions workflow for R tests.
- Issue templates and pull request template.

## Not included

The public repository does not include the full internal ARG score database, master workbook, validation issue files, or user-uploaded datasets.

## Current development mode

The app can run in demo mode with the synthetic score table. For full private-data testing, configure `ARG_SCORE_DB_PATH` to point to the private score table on a local or deployed server.

## Next recommended steps

1. Pull the repository locally.
2. Run the R tests.
3. Run the app in demo mode.
4. Test with the private score table locally.
5. Deploy to a Shiny-capable host.
