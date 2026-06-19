# Output table helpers

as_output_table <- function(x) {
  if (is.null(x)) {
    return(data.frame())
  }

  if (inherits(x, "tbl_df")) {
    x <- as.data.frame(x)
  }

  x
}

write_output_csv <- function(x, file) {
  x <- as_output_table(x)
  readr::write_csv(x, file, na = "")
  invisible(file)
}

empty_output_message <- function(message_text) {
  data.frame(message = message_text, stringsAsFactors = FALSE)
}

prepare_lookup_output <- function(x) {
  x <- as_output_table(x)
  if (nrow(x) == 0) return(empty_output_message("No matched ARG results available."))
  x
}

prepare_sample_output <- function(x) {
  x <- as_output_table(x)
  if (nrow(x) == 0) return(empty_output_message("No sample-level results available."))
  x
}

prepare_gene_output <- function(x) {
  x <- as_output_table(x)
  if (nrow(x) == 0) return(empty_output_message("No gene-level results available."))
  x
}

prepare_unmatched_output <- function(x) {
  x <- as_output_table(x)
  if (nrow(x) == 0) return(empty_output_message("No unmatched ARGs were found."))
  x
}
