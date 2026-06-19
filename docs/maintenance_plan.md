# Maintenance Plan

## Routine maintenance

Recommended review frequency: once per major score-table update or before each public demonstration.

Check:

- app starts successfully,
- example dataset still runs,
- upload templates match the app requirements,
- documentation matches the current interface,
- tests pass,
- private data are not staged for commit.

## Score-table maintenance

When the internal score table changes, record:

- date of update,
- score-table version,
- number of ARG records,
- number of complete records,
- major method changes,
- validation notes,
- person responsible for review.

## Documentation maintenance

Update these files when methods or outputs change:

- `README.md`,
- `docs/user_guide.md`,
- `docs/methods_summary.md`,
- `docs/score_interpretation.md`,
- `docs/data_dictionary_public.md`,
- `CHANGELOG.md`.

## Code maintenance

When helper functions change, update tests under:

```text
tests/testthat/
```

When the user interface changes, manually test:

- lookup tab,
- dataset-index tab,
- downloads,
- demo-mode warning,
- interpretation messages.

## Public-release maintenance

Before a public release, review:

- repository visibility,
- private-data exclusions,
- issue tracker content,
- release notes,
- citation wording,
- deployment notes.
