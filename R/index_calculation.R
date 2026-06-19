# Abundance-informed index calculation helpers
#
# These functions combine user-provided ARG abundance values with matched
# ARG hazard scores. They are intended for user query/upload results only.

library(dplyr)
library(stringr)

# Safely choose the final hazard-score column from a score table.
get_hazard_score_column <- function(score_db) {
  candidates <- c(
    "final_hc_score",
    "Final_HC_Score",
    "hc_score",
    "hazard_score"
  )

  found <- candidates[candidates %in% names(score_db)]

  if (length(found) == 0) {
    stop(
      "No final hazard-score column was found. Expected one of: ",
      paste(candidates, collapse = ", "),
      call. = FALSE
    )
  }

  found[[1]]
}

# Join uploaded records to matched score results.
#
# upload_df should contain SampleID, ARG, and Abundance.
# score_db should already be prepared with prepare_score_database().
match_uploaded_dataset <- function(upload_df, score_db) {
  if (!"ARG_norm" %in% names(upload_df)) {
    upload_df <- upload_df %>%
      mutate(ARG_norm = normalize_arg_name(ARG))
  }

  score_db <- prepare_score_database(score_db)
  score_col <- get_hazard_score_column(score_db)

  public_cols <- intersect(
    c(
      "arg_name",
      "ARG",
      "ARG_norm",
      "arg_family",
      "drug_class",
      "final_hc_score",
      "final_hc_score_percent",
      "criteria_completeness",
      "risk_category",
      "score_interpretation"
    ),
    names(score_db)
  )

  joined <- upload_df %>%
    left_join(
      score_db %>% select(all_of(public_cols)),
      by = "ARG_norm"
    )

  if (!"final_hc_score" %in% names(joined) && score_col %in% names(joined)) {
    joined <- joined %>% rename(final_hc_score = all_of(score_col))
  }

  joined %>%
    mutate(
      matched_status = if_else(!is.na(final_hc_score), "Matched", "Unmatched"),
      ARG_contribution = if_else(
        matched_status == "Matched",
        as.numeric(Abundance) * as.numeric(final_hc_score),
        NA_real_
      )
    )
}

# Calculate sample-level index values.
calculate_sample_index <- function(matched_upload_df) {
  matched_upload_df %>%
    group_by(SampleID) %>%
    summarise(
      total_ARG_records_uploaded = n(),
      matched_ARG_records = sum(matched_status == "Matched", na.rm = TRUE),
      unmatched_ARG_records = sum(matched_status == "Unmatched", na.rm = TRUE),
      unique_ARGs_uploaded = n_distinct(ARG),
      unique_ARGs_matched = n_distinct(ARG[matched_status == "Matched"]),
      total_abundance = sum(as.numeric(Abundance), na.rm = TRUE),
      matched_abundance = sum(as.numeric(Abundance[matched_status == "Matched"]), na.rm = TRUE),
      abundance_informed_index = sum(ARG_contribution, na.rm = TRUE),
      unmatched_warning = if_else(
        unmatched_ARG_records > 0,
        "One or more ARGs were unmatched; interpret the index with caution.",
        "All uploaded ARG records were matched."
      ),
      .groups = "drop"
    ) %>%
    arrange(desc(abundance_informed_index))
}

# Return gene-level contribution table for the user's uploaded data.
calculate_gene_contributions <- function(matched_upload_df) {
  matched_upload_df %>%
    mutate(
      ARG_contribution = as.numeric(ARG_contribution),
      Abundance = as.numeric(Abundance)
    ) %>%
    select(
      any_of(c(
        "SampleID",
        "ARG",
        "arg_name",
        "arg_family",
        "drug_class",
        "Abundance",
        "final_hc_score",
        "final_hc_score_percent",
        "risk_category",
        "ARG_contribution",
        "matched_status"
      ))
    ) %>%
    arrange(SampleID, desc(ARG_contribution))
}

# Return top contributing ARGs within each sample.
top_contributors <- function(gene_contribution_df, n = 10) {
  gene_contribution_df %>%
    filter(matched_status == "Matched") %>%
    group_by(SampleID) %>%
    slice_max(order_by = ARG_contribution, n = n, with_ties = FALSE) %>%
    ungroup() %>%
    arrange(SampleID, desc(ARG_contribution))
}

# Return unmatched ARGs from the uploaded dataset.
unmatched_uploaded_args <- function(matched_upload_df) {
  matched_upload_df %>%
    filter(matched_status == "Unmatched") %>%
    distinct(SampleID, ARG, ARG_norm, Abundance) %>%
    arrange(SampleID, ARG)
}

# One-call wrapper for uploaded dataset analysis.
analyze_uploaded_dataset <- function(upload_df, score_db) {
  matched <- match_uploaded_dataset(upload_df, score_db)
  gene_contributions <- calculate_gene_contributions(matched)

  list(
    matched_records = matched,
    sample_index = calculate_sample_index(matched),
    gene_contributions = gene_contributions,
    top_contributors = top_contributors(gene_contributions),
    unmatched_args = unmatched_uploaded_args(matched)
  )
}
