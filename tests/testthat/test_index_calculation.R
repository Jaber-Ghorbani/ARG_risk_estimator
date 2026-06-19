testthat::test_that("uploaded datasets are matched to score table", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  score_db <- data.frame(
    ARG = c("sul1", "tetM"),
    final_hc_score = c(0.50, 0.25),
    stringsAsFactors = FALSE
  )

  uploaded <- data.frame(
    SampleID = c("S1", "S1", "S2"),
    ARG = c("sul1", "tetM", "unknown"),
    Abundance = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  matched <- match_uploaded_dataset(uploaded, score_db)

  testthat::expect_equal(nrow(matched), 3)
  testthat::expect_true("matched" %in% names(matched))
  testthat::expect_equal(sum(matched$matched), 2)
  testthat::expect_equal(sum(!matched$matched), 1)
})

testthat::test_that("sample-level index is calculated correctly", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  matched <- data.frame(
    SampleID = c("S1", "S1", "S2"),
    ARG = c("sul1", "tetM", "unknown"),
    Abundance = c(10, 20, 30),
    final_hc_score = c(0.50, 0.25, NA_real_),
    matched = c(TRUE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )

  index <- calculate_sample_index(matched)

  testthat::expect_equal(nrow(index), 2)
  testthat::expect_equal(index$matched_args[index$SampleID == "S1"], 2)
  testthat::expect_equal(index$unmatched_args[index$SampleID == "S1"], 0)
  testthat::expect_equal(index$abundance_informed_index[index$SampleID == "S1"], 10)
  testthat::expect_equal(index$matched_args[index$SampleID == "S2"], 0)
  testthat::expect_equal(index$unmatched_args[index$SampleID == "S2"], 1)
})

testthat::test_that("gene-level contributions are calculated correctly", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  matched <- data.frame(
    SampleID = c("S1", "S1", "S2"),
    ARG = c("sul1", "tetM", "unknown"),
    Abundance = c(10, 20, 30),
    final_hc_score = c(0.50, 0.25, NA_real_),
    matched = c(TRUE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )

  contributions <- calculate_gene_contributions(matched)

  testthat::expect_equal(nrow(contributions), 2)
  testthat::expect_true("arg_contribution" %in% names(contributions))
  testthat::expect_equal(sum(contributions$arg_contribution), 10)
})

testthat::test_that("top contributors are returned by sample", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  contributions <- data.frame(
    SampleID = c("S1", "S1", "S1"),
    ARG = c("sul1", "tetM", "ermB"),
    Abundance = c(10, 20, 5),
    final_hc_score = c(0.50, 0.25, 0.90),
    arg_contribution = c(5.0, 5.0, 4.5),
    stringsAsFactors = FALSE
  )

  top <- top_contributors(contributions, n = 2)

  testthat::expect_equal(nrow(top), 2)
  testthat::expect_true(all(top$ARG %in% c("sul1", "tetM")))
})

testthat::test_that("unmatched uploaded ARGs are summarized", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  matched <- data.frame(
    SampleID = c("S1", "S2", "S2"),
    ARG = c("unknownA", "unknownA", "unknownB"),
    Abundance = c(5, 10, 20),
    matched = c(FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )

  unmatched <- unmatched_uploaded_args(matched)

  testthat::expect_equal(nrow(unmatched), 2)
  testthat::expect_equal(unmatched$n_records[unmatched$ARG == "unknownA"], 2)
})

testthat::test_that("full uploaded-dataset analysis returns expected components", {
  source("R/input_validation.R")
  source("R/score_lookup.R")
  source("R/index_calculation.R")

  score_db <- data.frame(
    ARG = c("sul1", "tetM"),
    final_hc_score = c(0.50, 0.25),
    stringsAsFactors = FALSE
  )

  uploaded <- data.frame(
    SampleID = c("S1", "S1", "S2"),
    ARG = c("sul1", "tetM", "unknown"),
    Abundance = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  out <- analyze_uploaded_dataset(uploaded, score_db)

  testthat::expect_true(all(c("matched_data", "sample_index", "gene_contributions", "top_contributors", "unmatched_args") %in% names(out)))
  testthat::expect_equal(nrow(out$sample_index), 2)
})
