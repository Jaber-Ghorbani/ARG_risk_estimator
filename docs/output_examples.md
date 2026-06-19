# Output Examples

This page gives simplified examples of the main app outputs.

## Lookup output

| query_arg | matched_status | matched_arg_name | final_hc_score | risk_category |
|---|---|---|---:|---|
| sul1 | Matched | sul1 | 0.50 | Higher relative priority |
| tetM | Matched | tetM | 0.45 | Moderate relative priority |
| unknownARG_demo | Unmatched |  |  |  |

## Gene-contribution output

| SampleID | ARG | Abundance | final_hc_score | ARG_contribution | matched_status |
|---|---|---:|---:|---:|---|
| Sample_1 | sul1 | 1200 | 0.50 | 600 | Matched |
| Sample_1 | tetM | 450 | 0.45 | 202.5 | Matched |
| Sample_1 | unknownARG_demo | 90 |  |  | Unmatched |

## Sample-index output

| SampleID | matched_ARG_records | unmatched_ARG_records | abundance_informed_index |
|---|---:|---:|---:|
| Sample_1 | 2 | 1 | 802.5 |

## Interpretation

The sample-level index is the sum of matched gene-level contributions. Unmatched ARGs are reported separately and should be reviewed. Index values should only be compared among samples with the same abundance unit and normalization approach.
