# Helper functions for ARG score lookup

find_first_column <- function(data, candidates) {
  matches <- candidates[candidates %in% names(data)]
  if (length(matches) == 0) {
    return(NA_character_)
  }
  matches[[1]]
}

prepare_score_database <- function(score_db) {
  stopifnot(is.data.frame(score_db))

  arg_col <- find_first_column(score_db, c("arg_name", "ARG", "ARG_name", "gene", "aro_name"))
  norm_col <- find_first_column(score_db, c("normalized_arg_name", "arg_normalized", "normalized_ARG", "ARG_normalized"))
  score_col <- find_first_column(score_db, c("final_hc_score", "Final_HC_Score", "final_score", "HC_score"))

  if (is.na(arg_col)) {
    stop("The score database must contain an ARG-name column.", call. = FALSE)
  }

  if (is.na(score_col)) {
    stop("The score database must contain a final hazard-score column.", call. = FALSE)
  }

  prepared <- score_db

  prepared$.arg_name <- as.character(prepared[[arg_col]])

  if (is.na(norm_col)) {
    prepared$.normalized_arg_name <- normalize_arg_name(prepared$.arg_name)
  } else {
    prepared$.normalized_arg_name <- as.character(prepared[[norm_col]])
    missing_norm <- is.na(prepared$.normalized_arg_name) | prepared$.normalized_arg_name == ""
    prepared$.normalized_arg_name[missing_norm] <- normalize_arg_name(prepared$.arg_name[missing_norm])
  }

  prepared$.final_hc_score <- suppressWarnings(as.numeric(prepared[[score_col]]))

  percent_col <- find_first_column(prepared, c("final_hc_score_percent", "Final_HC_Score_Percent", "score_percent"))
  family_col <- find_first_column(prepared, c("arg_family", "ARG_family", "family"))
  drug_col <- find_first_column(prepared, c("drug_class", "Drug_Class", "drug_class_clean", "antibiotic_class"))
  complete_col <- find_first_column(prepared, c("criteria_completeness", "criteria_complete", "completeness"))

  if (is.na(percent_col)) {
    prepared$.final_hc_score_percent <- round(prepared$.final_hc_score * 100, 2)
  } else {
    prepared$.final_hc_score_percent <- suppressWarnings(as.numeric(prepared[[percent_col]]))
  }

  prepared$.arg_family <- if (is.na(family_col)) NA_character_ else as.character(prepared[[family_col]])
  prepared$.drug_class <- if (is.na(drug_col)) NA_character_ else as.character(prepared[[drug_col]])
  prepared$.criteria_completeness <- if (is.na(complete_col)) NA_character_ else as.character(prepared[[complete_col]])

  prepared$.risk_category <- derive_risk_category(prepared$.final_hc_score)
  prepared
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
  if (!is.data.frame(score_db)) {
    stop("score_db must be a data frame.", call. = FALSE)
  }

  query_args <- unique(parse_lookup_args(query_args))
  validation <- validate_lookup_input(query_args)
  if (!isTRUE(validation$ok)) {
    stop(validation$message, call. = FALSE)
  }

  prepared_db <- prepare_score_database(score_db)

  query_tbl <- tibble::tibble(
    query_arg = query_args,
    query_normalized_arg = normalize_arg_name(query_args)
  )

  joined <- dplyr::left_join(
    query_tbl,
    prepared_db,
    by = c("query_normalized_arg" = ".normalized_arg_name")
  )

  joined %>%
    dplyr::mutate(
      matched_status = dplyr::if_else(is.na(.arg_name), "Unmatched", "Matched"),
      interpretation = score_interpretation(.final_hc_score)
    ) %>%
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

matched_lookup_results <- function(lookup_results) {
  lookup_results %>%
    dplyr::filter(.data$matched_status == "Matched")
}

unmatched_lookup_results <- function(lookup_results) {
  lookup_results %>%
    dplyr::filter(.data$matched_status == "Unmatched") %>%
    dplyr::select(.data$query_arg, .data$matched_status)
}

lookup_summary <- function(lookup_results) {
  total <- nrow(lookup_results)
  matched <- sum(lookup_results$matched_status == "Matched", na.rm = TRUE)
  unmatched <- sum(lookup_results$matched_status == "Unmatched", na.rm = TRUE)

  tibble::tibble(
    total_queries = total,
    matched_queries = matched,
    unmatched_queries = unmatched,
    match_rate_percent = ifelse(total == 0, NA_real_, round(100 * matched / total, 1))
  )
}
