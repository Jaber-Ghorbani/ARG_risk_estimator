find_first_column <- function(data, candidates) {
  hit <- candidates[candidates %in% names(data)]
  if (length(hit) == 0) NA_character_ else hit[[1]]
}

prepare_score_database <- function(score_db) {
  stopifnot(is.data.frame(score_db))
  arg_col <- find_first_column(score_db, c("arg_name", "ARG", "ARG_name", "gene", "aro_name", "ARO_name"))
  norm_col <- find_first_column(score_db, c("normalized_arg_name", "arg_normalized", "normalized_ARG", "ARG_normalized"))
  score_col <- find_first_column(score_db, c("final_hc_score", "Final_HC_Score", "final_score", "HC_score", "hazard_score"))
  if (is.na(arg_col)) stop("The score table must contain an ARG-name column.", call. = FALSE)
  if (is.na(score_col)) stop("The score table must contain a final hazard-score column.", call. = FALSE)

  out <- score_db
  out$.arg_name <- as.character(out[[arg_col]])
  out$.normalized_arg_name <- if (is.na(norm_col)) normalize_arg_name(out$.arg_name) else as.character(out[[norm_col]])
  miss <- is.na(out$.normalized_arg_name) | out$.normalized_arg_name == ""
  out$.normalized_arg_name[miss] <- normalize_arg_name(out$.arg_name[miss])
  out$.final_hc_score <- suppressWarnings(as.numeric(out[[score_col]]))

  percent_col <- find_first_column(out, c("final_hc_score_percent", "Final_HC_Score_Percent", "score_percent"))
  family_col <- find_first_column(out, c("arg_family", "ARG_family", "family"))
  drug_col <- find_first_column(out, c("drug_class", "Drug_Class", "drug_class_clean", "antibiotic_class"))
  complete_col <- find_first_column(out, c("criteria_completeness", "criteria_complete", "completeness"))

  out$.final_hc_score_percent <- if (is.na(percent_col)) round(out$.final_hc_score * 100, 2) else suppressWarnings(as.numeric(out[[percent_col]]))
  out$.arg_family <- if (is.na(family_col)) NA_character_ else as.character(out[[family_col]])
  out$.drug_class <- if (is.na(drug_col)) NA_character_ else as.character(out[[drug_col]])
  out$.criteria_completeness <- if (is.na(complete_col)) NA_character_ else as.character(out[[complete_col]])
  out$.risk_category <- derive_risk_category(out$.final_hc_score)
  dplyr::distinct(out, .data$.normalized_arg_name, .keep_all = TRUE)
}

derive_risk_category <- function(score) {
  score <- suppressWarnings(as.numeric(score))
  dplyr::case_when(
    is.na(score) ~ NA_character_,
    score < 0.25 ~ "Lower relative priority",
    score < 0.50 ~ "Moderate relative priority",
    score < 0.75 ~ "Higher relative priority",
    TRUE ~ "Very high relative priority"
  )
}

score_interpretation <- function(score) {
  score <- suppressWarnings(as.numeric(score))
  dplyr::case_when(
    is.na(score) ~ "No score available.",
    score < 0.25 ~ "Lower relative priority within the current scoring framework.",
    score < 0.50 ~ "Moderate relative priority within the current scoring framework.",
    score < 0.75 ~ "Higher relative priority within the current scoring framework.",
    TRUE ~ "Very high relative priority within the current scoring framework."
  )
}

lookup_arg_scores <- function(query_args, score_db) {
  if (!is.data.frame(score_db)) stop("score_db must be a data frame.", call. = FALSE)
  query_tbl <- if (is.data.frame(query_args)) {
    dplyr::transmute(query_args, query_arg = as.character(.data$ARG))
  } else {
    dplyr::transmute(parse_lookup_args(query_args), query_arg = as.character(.data$ARG))
  }
  query_tbl <- query_tbl |>
    dplyr::mutate(query_normalized_arg = normalize_arg_name(.data$query_arg)) |>
    dplyr::filter(.data$query_normalized_arg != "") |>
    dplyr::distinct(.data$query_normalized_arg, .keep_all = TRUE)
  if (nrow(query_tbl) == 0) stop("Enter at least one ARG name before running the lookup.", call. = FALSE)

  joined <- dplyr::left_join(
    query_tbl,
    prepare_score_database(score_db),
    by = c("query_normalized_arg" = ".normalized_arg_name")
  )
  joined |>
    dplyr::mutate(
      matched_status = dplyr::if_else(is.na(.data$.arg_name), "Unmatched", "Matched"),
      interpretation = score_interpretation(.data$.final_hc_score)
    ) |>
    dplyr::transmute(
      query_arg = .data$query_arg,
      matched_status = .data$matched_status,
      matched_arg_name = .data$.arg_name,
      arg_family = .data$.arg_family,
      drug_class = .data$.drug_class,
      final_hc_score = round(.data$.final_hc_score, 4),
      final_hc_score_percent = round(.data$.final_hc_score_percent, 2),
      risk_category = .data$.risk_category,
      criteria_completeness = .data$.criteria_completeness,
      interpretation = .data$interpretation
    )
}

matched_lookup_results <- function(lookup_results) dplyr::filter(lookup_results, .data$matched_status == "Matched")
unmatched_lookup_results <- function(lookup_results) dplyr::select(dplyr::filter(lookup_results, .data$matched_status == "Unmatched"), .data$query_arg, .data$matched_status)

lookup_summary <- function(lookup_results) {
  total <- nrow(lookup_results)
  matched <- sum(lookup_results$matched_status == "Matched", na.rm = TRUE)
  tibble::tibble(
    total_queries = total,
    matched_queries = matched,
    unmatched_queries = total - matched,
    match_rate_percent = ifelse(total == 0, NA_real_, round(100 * matched / total, 1))
  )
}
