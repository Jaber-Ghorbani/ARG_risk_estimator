# Plot helper functions for ARG Risk & Abundance-Informed Index Tool

make_top_contributors_plot <- function(contribution_data, n = 15) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plotting.")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for plotting.")
  }

  required_cols <- c("ARG", "ARG_contribution")
  missing_cols <- setdiff(required_cols, names(contribution_data))
  if (length(missing_cols) > 0) {
    stop("Missing required plotting columns: ", paste(missing_cols, collapse = ", "))
  }

  plot_data <- contribution_data |>
    dplyr::filter(!is.na(.data$ARG_contribution)) |>
    dplyr::group_by(.data$ARG) |>
    dplyr::summarise(
      ARG_contribution = sum(.data$ARG_contribution, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$ARG_contribution)) |>
    dplyr::slice_head(n = n)

  if (nrow(plot_data) == 0) {
    return(ggplot2::ggplot() + ggplot2::theme_void() + ggplot2::labs(title = "No matched ARG contributions available"))
  }

  plot_data$ARG <- stats::reorder(plot_data$ARG, plot_data$ARG_contribution)

  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$ARG, y = .data$ARG_contribution)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Top ARG contributors",
      x = "ARG",
      y = "Abundance-informed contribution"
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

make_sample_index_plot <- function(sample_index_data) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plotting.")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for plotting.")
  }

  required_cols <- c("SampleID", "abundance_informed_index")
  missing_cols <- setdiff(required_cols, names(sample_index_data))
  if (length(missing_cols) > 0) {
    stop("Missing required plotting columns: ", paste(missing_cols, collapse = ", "))
  }

  plot_data <- sample_index_data |>
    dplyr::filter(!is.na(.data$abundance_informed_index)) |>
    dplyr::arrange(dplyr::desc(.data$abundance_informed_index))

  if (nrow(plot_data) == 0) {
    return(ggplot2::ggplot() + ggplot2::theme_void() + ggplot2::labs(title = "No sample-level index values available"))
  }

  plot_data$SampleID <- stats::reorder(plot_data$SampleID, plot_data$abundance_informed_index)

  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$SampleID, y = .data$abundance_informed_index)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Sample-level abundance-informed index",
      x = "Sample",
      y = "Index"
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

make_match_summary_plot <- function(summary_data) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plotting.")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for plotting.")
  }
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("Package 'tidyr' is required for plotting.")
  }

  required_cols <- c("SampleID", "matched_ARGs", "unmatched_ARGs")
  missing_cols <- setdiff(required_cols, names(summary_data))
  if (length(missing_cols) > 0) {
    stop("Missing required plotting columns: ", paste(missing_cols, collapse = ", "))
  }

  plot_data <- summary_data |>
    dplyr::select(.data$SampleID, .data$matched_ARGs, .data$unmatched_ARGs) |>
    tidyr::pivot_longer(
      cols = c("matched_ARGs", "unmatched_ARGs"),
      names_to = "match_status",
      values_to = "count"
    )

  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$SampleID, y = .data$count, fill = .data$match_status)) +
    ggplot2::geom_col(position = "stack") +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Matched and unmatched ARGs by sample",
      x = "Sample",
      y = "ARG record count",
      fill = "Match status"
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

plotly_if_available <- function(ggplot_object) {
  if (requireNamespace("plotly", quietly = TRUE)) {
    return(plotly::ggplotly(ggplot_object))
  }
  ggplot_object
}
