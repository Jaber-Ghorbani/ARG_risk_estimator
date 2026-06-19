# input_validation.R

normalize_arg_name <- function(x) {
  if (is.null(x)) return(character(0))
  x <- as.character(x)
  x <- stringr::str_trim(x)
  x <- stringr::str_to_lower(x)
  stringr::str_replace_all(x, "[^a-z0-9]", "")
}

parse_lookup_args <- function(text) {
  if (is.null(text)) {
    return(tibble::tibble(ARG = character(0), normalized_arg_name = character(0)))
  }

  text <- paste(as.character(text), collapse = "\n")
  if (!nzchar(stringr::str_trim(text))) {
    return(tibble::tibble(ARG = character(0), normalized_arg_name = character(0)))
  }

  arg_vector <- unlist(stringr::str_split(text, pattern = "[,;\n\r\t]+"))
  arg_vector <- stringr::str_trim(arg_vector)
  arg_vector <- arg_vector[nzchar(arg_vector)]
  arg_vector <- unique(arg_vector)

  tibble::tibble(
    ARG = arg_vector,
    normalized_arg_name = normalize_arg_name(arg_vector)
  )
}

validate_lookup_input <- function(text) {
  parsed <- parse_lookup_args(text)
  if (nrow(parsed) == 0) {
    return(list(valid = FALSE, data = parsed, message = "Enter at least one ARG name before running the lookup."))
  }
  if (any(!nzchar(parsed$normalized_arg_name))) {
    return(list(valid = FALSE, data = parsed, message = "One or more ARG names could not be normalized. Check the input text."))
  }
  list(valid = TRUE, data = parsed, message = "Lookup input is valid.")
}

validate_upload_data <- function(dat) {
  required_cols <- c("SampleID", "ARG", "Abundance")
  if (is.null(dat) || !is.data.frame(dat)) {
    return(list(valid = FALSE, data = NULL, message = "Uploaded file could not be read as a table."))
  }
  missing_cols <- setdiff(required_cols, names(dat))
  if (length(missing_cols) > 0) {
    return(list(
      valid = FALSE,
      data = dat,
      message = paste0("Missing required column(s): ", paste(missing_cols, collapse = ", "), ". Required columns are SampleID, ARG, and Abundance.")
    ))
  }

  dat <- dat |>
    dplyr::mutate(
      SampleID = as.character(.data$SampleID),
      ARG = as.character(.data$ARG),
      Abundance = suppressWarnings(as.numeric(.data$Abundance)),
      normalized_arg_name = normalize_arg_name(.data$ARG)
    )

  if (any(!nzchar(stringr::str_trim(dat$SampleID)) | is.na(dat$SampleID))) {
    return(list(valid = FALSE, data = dat, message = "SampleID contains missing or blank values."))
  }
  if (any(!nzchar(stringr::str_trim(dat$ARG)) | is.na(dat$ARG))) {
    return(list(valid = FALSE, data = dat, message = "ARG contains missing or blank values."))
  }
  if (any(is.na(dat$Abundance))) {
    return(list(valid = FALSE, data = dat, message = "Abundance must be numeric for every row."))
  }
  if (any(dat$Abundance < 0)) {
    return(list(valid = FALSE, data = dat, message = "Abundance values must be non-negative."))
  }
  if (any(!nzchar(dat$normalized_arg_name))) {
    return(list(valid = FALSE, data = dat, message = "One or more ARG names could not be normalized. Check the ARG column."))
  }
  list(valid = TRUE, data = dat, message = "Uploaded dataset is valid.")
}

validation_message <- function(validation_result) {
  if (is.null(validation_result$message)) return("")
  validation_result$message
}
