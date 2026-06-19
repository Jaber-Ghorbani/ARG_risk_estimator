testthat::test_that("as_output_table returns data frames and keeps empty tables stable", {
  source("R/report_download.R")

  empty_tbl <- as_output_table(NULL)
  testthat::expect_true(is.data.frame(empty_tbl))
  testthat::expect_equal(nrow(empty_tbl), 0)

  input_tbl <- data.frame(ARG = "sul1", final_hc_score = 0.42)
  output_tbl <- as_output_table(input_tbl)
  testthat::expect_true(is.data.frame(output_tbl))
  testthat::expect_equal(nrow(output_tbl), 1)
  testthat::expect_equal(output_tbl$ARG[[1]], "sul1")
})

testthat::test_that("empty_output_message returns a usable one-row table", {
  source("R/report_download.R")

  msg <- empty_output_message("No records available")

  testthat::expect_true(is.data.frame(msg))
  testthat::expect_equal(nrow(msg), 1)
  testthat::expect_true("message" %in% names(msg))
  testthat::expect_equal(msg$message[[1]], "No records available")
})

testthat::test_that("prepare_lookup_output returns matched records or message table", {
  source("R/report_download.R")

  lookup_obj <- list(
    matched = data.frame(ARG = "sul1", final_hc_score = 0.42),
    unmatched = data.frame(ARG = "unknownARG")
  )

  matched_output <- prepare_lookup_output(lookup_obj)
  testthat::expect_equal(nrow(matched_output), 1)
  testthat::expect_equal(matched_output$ARG[[1]], "sul1")

  empty_output <- prepare_lookup_output(list(matched = data.frame()))
  testthat::expect_true("message" %in% names(empty_output))
})

testthat::test_that("prepare_sample_output returns sample index output", {
  source("R/report_download.R")

  analysis_obj <- list(
    sample_index = data.frame(
      SampleID = c("Sample_1", "Sample_2"),
      abundance_informed_index = c(100, 200)
    )
  )

  output <- prepare_sample_output(analysis_obj)
  testthat::expect_equal(nrow(output), 2)
  testthat::expect_true("abundance_informed_index" %in% names(output))
})

testthat::test_that("prepare_gene_output returns gene contribution output", {
  source("R/report_download.R")

  analysis_obj <- list(
    gene_contributions = data.frame(
      SampleID = "Sample_1",
      ARG = "sul1",
      arg_contribution = 100
    )
  )

  output <- prepare_gene_output(analysis_obj)
  testthat::expect_equal(nrow(output), 1)
  testthat::expect_equal(output$ARG[[1]], "sul1")
})

testthat::test_that("prepare_unmatched_output returns unmatched ARG output", {
  source("R/report_download.R")

  analysis_obj <- list(
    unmatched = data.frame(ARG = "unknownARG", n_records = 1)
  )

  output <- prepare_unmatched_output(analysis_obj)
  testthat::expect_equal(nrow(output), 1)
  testthat::expect_equal(output$ARG[[1]], "unknownARG")
})

testthat::test_that("write_output_csv writes a CSV file", {
  source("R/report_download.R")

  output_path <- tempfile(fileext = ".csv")
  tbl <- data.frame(ARG = "sul1", final_hc_score = 0.42)

  result_path <- write_output_csv(tbl, output_path)

  testthat::expect_true(file.exists(result_path))
  imported <- read.csv(result_path)
  testthat::expect_equal(imported$ARG[[1]], "sul1")
})
