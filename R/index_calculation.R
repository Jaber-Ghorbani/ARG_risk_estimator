# Abundance-informed index calculation helpers

match_uploaded_dataset <- function(upload_df, score_db) {
  if (!is.data.frame(upload_df)) stop("upload_df must be a data frame.", call. = FALSE)

  upload_df <- upload_df |>
    dplyr::mutate(
      SampleID = as.character(.data$SampleID),
      ARG = as.character(.data$ARG),
      Abundance = suppressWarnings(as.numeric(.data$Abundance)),
      ARG_norm = normalize_arg_name(.data$ARG)
    )

  score_db <- prepare_score_database(score_db) |>
    dplyr::transmute(
      ARG_norm = .data$.normalized_arg_name,
      matched_arg_name = .data$.arg_name,
      arg_family = .data$.arg_family,
      drug_class = .data$.drug_class,
      final_hc_score = .data$.final_hc_score,
      final_hc_score_percent = .data$.final_hc_score_percent,
      risk_category = .data$.risk_category,
      criteria_completeness = .data$.criteria_completeness
    )

  upload_df |>
    dplyr::left_join(score_db, by = "ARG_norm") |>
    dplyr::mutate(
      matched_status = dplyr::if_else(is.na(.data$final_hc_score), "Unmatched", "Matched"),
      ARG_contribution = dplyr::if_else(
        .data$matched_status == "Matched",
        as.numeric(.data$Abundance) * as.numeric(.data$final_hc_score),
        NA_real_
      )
    )
}

calculate_sample_index <- function(matched_upload_df) {
  matched_upload_df |>
    dplyr::group_by(.data$SampleID) |>
    dplyr::summarise(
      total_ARG_records_uploaded = dplyr::n(),
      matched_ARG_records = sum(.data$matched_status == "Matched", na.rm = TRUE),
      unmatched_ARG_records = sum(.data$matched_status == "Unmatched", na.rm = TRUE),
      unique_ARGs_uploaded = dplyr::n_distinct(.data$ARG),
      unique_ARGs_matched = dplyr::n_distinct(.data$ARG[.data$matched_status == "Matched"]),
      total_abundance = sum(as.numeric(.data$Abundance), na.rm = TRUE),
      matched_abundance = sum(as.numeric(.data$Abundance[.data$matched_status == "Matched"]), na.rm = TRUE),
      abundance_informed_index = sum(.data$ARG_contribution, na.rm = TRUE),
      unmatched_warning = dplyr::if_else(
        .data$unmatched_ARG_records > 0,
        "One or more ARGs were unmatched; interpret the index with caution.",
        "All uploaded ARG records were matched."
      ),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$abundance_informed_index))
}

calculate_gene_contributions <- function(matched_upload_df) {
  matched_upload_df |>
    dplyr::mutate(
      ARG_contribution = as.numeric(.data$ARG_contribution),
      Abundance = as.numeric(.data$Abundance)
    ) |>
    dplyr::select(dplyr::any_of(c(
      "SampleID", "ARG", "matched_arg_name", "arg_family", "drug_class",
      "Abundance", "final_hc_score", "final_hc_score_percent", "risk_category",
      "ARG_contribution", "matched_status"
    ))) |>
    dplyr::arrange(.data$SampleID, dplyr::desc(.data$ARG_contribution))
}

top_contributors <- function(gene_contribution_df, n = 10) {
  gene_contribution_df |>
    dplyr::filter(.data$matched_status == "Matched") |>
    dplyr::group_by(.data$SampleID) |>
    dplyr::slice_max(order_by = .data$ARG_contribution, n = n, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$SampleID, dplyr::desc(.data$ARG_contribution))
}

unmatched_uploaded_args <- function(matched_upload_df) {
  matched_upload_df |>
    dplyr::filter(.data$matched_status == "Unmatched") |>
    dplyr::distinct(.data$SampleID, .data$ARG, .data$ARG_norm, .data$Abundance) |>
    dplyr::arrange(.data$SampleID, .data$ARG)
}

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
