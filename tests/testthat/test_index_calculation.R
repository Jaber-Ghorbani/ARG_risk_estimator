testthat::test_that("uploaded datasets are matched to score table", {
  score_db <- data.frame(ARG = c("sul1", "tetM"), final_hc_score = c(0.50, 0.25))
  uploaded <- data.frame(SampleID = c("S1", "S1", "S2"), ARG = c("sul1", "tetM", "unknown"), Abundance = c(10, 20, 30))
  matched <- match_uploaded_dataset(uploaded, score_db)
  expect_equal(nrow(matched), 3)
  expect_equal(sum(matched$matched_status == "Matched"), 2)
  expect_equal(sum(matched$matched_status == "Unmatched"), 1)
})

testthat::test_that("sample-level index is calculated correctly", {
  matched <- data.frame(
    SampleID = c("S1", "S1", "S2"),
    ARG = c("sul1", "tetM", "unknown"),
    Abundance = c(10, 20, 30),
    matched_status = c("Matched", "Matched", "Unmatched"),
    ARG_contribution = c(5, 5, NA_real_)
  )
  index <- calculate_sample_index(matched)
  expect_equal(index$matched_ARG_records[index$SampleID == "S1"], 2)
  expect_equal(index$unmatched_ARG_records[index$SampleID == "S1"], 0)
  expect_equal(index$abundance_informed_index[index$SampleID == "S1"], 10)
  expect_equal(index$matched_ARG_records[index$SampleID == "S2"], 0)
  expect_equal(index$unmatched_ARG_records[index$SampleID == "S2"], 1)
})

testthat::test_that("gene-level contributions are returned", {
  matched <- data.frame(
    SampleID = c("S1", "S1"), ARG = c("sul1", "tetM"), Abundance = c(10, 20),
    final_hc_score = c(0.50, 0.25), final_hc_score_percent = c(50, 25),
    ARG_contribution = c(5, 5), matched_status = c("Matched", "Matched")
  )
  contributions <- calculate_gene_contributions(matched)
  expect_equal(nrow(contributions), 2)
  expect_true("ARG_contribution" %in% names(contributions))
  expect_equal(sum(contributions$ARG_contribution), 10)
})

testthat::test_that("top contributors are returned by sample", {
  contributions <- data.frame(
    SampleID = c("S1", "S1", "S1"), ARG = c("sul1", "tetM", "ermB"),
    ARG_contribution = c(5.0, 5.0, 4.5), matched_status = c("Matched", "Matched", "Matched")
  )
  top <- top_contributors(contributions, n = 2)
  expect_equal(nrow(top), 2)
})

testthat::test_that("unmatched uploaded ARGs are returned", {
  matched <- data.frame(
    SampleID = c("S1", "S2"), ARG = c("unknownA", "unknownB"),
    ARG_norm = c("unknowna", "unknownb"), Abundance = c(5, 10),
    matched_status = c("Unmatched", "Unmatched")
  )
  unmatched <- unmatched_uploaded_args(matched)
  expect_equal(nrow(unmatched), 2)
})

testthat::test_that("full uploaded-dataset analysis returns expected components", {
  score_db <- data.frame(ARG = c("sul1", "tetM"), final_hc_score = c(0.50, 0.25))
  uploaded <- data.frame(SampleID = c("S1", "S1", "S2"), ARG = c("sul1", "tetM", "unknown"), Abundance = c(10, 20, 30))
  out <- analyze_uploaded_dataset(uploaded, score_db)
  expect_true(all(c("matched_records", "sample_index", "gene_contributions", "top_contributors", "unmatched_args") %in% names(out)))
  expect_equal(nrow(out$sample_index), 2)
})
