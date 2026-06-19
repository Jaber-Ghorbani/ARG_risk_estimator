testthat::test_that("risk categories are derived from numeric scores", {
  expect_equal(derive_risk_category(0.10), "Lower relative priority")
  expect_equal(derive_risk_category(0.30), "Moderate relative priority")
  expect_equal(derive_risk_category(0.60), "Higher relative priority")
  expect_equal(derive_risk_category(0.90), "Very high relative priority")
  expect_true(is.na(derive_risk_category(NA_real_)))
})

testthat::test_that("score interpretation returns expected text", {
  expect_match(score_interpretation(0.10), "Lower relative priority")
  expect_match(score_interpretation(0.30), "Moderate relative priority")
  expect_match(score_interpretation(0.60), "Higher relative priority")
  expect_match(score_interpretation(0.90), "Very high relative priority")
  expect_equal(score_interpretation(NA_real_), "No score available.")
})

testthat::test_that("score database preparation creates standard fields", {
  demo_scores <- data.frame(
    ARG = c("sul1", "blaTEM", "tetM"),
    final_hc_score = c(0.42, 0.63, 0.28),
    drug_class = c("Sulfonamide", "Beta-lactam", "Tetracycline"),
    stringsAsFactors = FALSE
  )

  prepared <- prepare_score_database(demo_scores)

  expect_true(all(c(
    ".arg_name",
    ".normalized_arg_name",
    ".final_hc_score",
    ".final_hc_score_percent",
    ".drug_class",
    ".risk_category"
  ) %in% names(prepared)))
  expect_equal(prepared$.final_hc_score_percent, c(42, 63, 28))
})

testthat::test_that("score database preparation rejects missing ARG column", {
  bad_scores <- data.frame(
    final_hc_score = c(0.42, 0.63),
    stringsAsFactors = FALSE
  )

  expect_error(
    prepare_score_database(bad_scores),
    "ARG-name column"
  )
})

testthat::test_that("score database preparation rejects missing score column", {
  bad_scores <- data.frame(
    ARG = c("sul1", "blaTEM"),
    stringsAsFactors = FALSE
  )

  expect_error(
    prepare_score_database(bad_scores),
    "hazard-score column"
  )
})

testthat::test_that("ARG lookup returns matched and unmatched records", {
  demo_scores <- data.frame(
    ARG = c("sul1", "blaTEM", "tetM"),
    final_hc_score = c(0.42, 0.63, 0.28),
    drug_class = c("Sulfonamide", "Beta-lactam", "Tetracycline"),
    criteria_completeness = c("Complete", "Complete", "Partial"),
    stringsAsFactors = FALSE
  )

  result <- lookup_arg_scores(c("sul1", "blaTEM", "unknownARG"), demo_scores)

  expect_equal(nrow(result), 3)
  expect_equal(sum(result$matched_status == "Matched"), 2)
  expect_equal(sum(result$matched_status == "Unmatched"), 1)
  expect_true("unknownARG" %in% result$query_arg)
})

testthat::test_that("matched and unmatched helpers separate lookup results", {
  lookup_results <- data.frame(
    query_arg = c("sul1", "unknownARG"),
    matched_status = c("Matched", "Unmatched"),
    matched_arg_name = c("sul1", NA_character_),
    stringsAsFactors = FALSE
  )

  expect_equal(nrow(matched_lookup_results(lookup_results)), 1)
  expect_equal(nrow(unmatched_lookup_results(lookup_results)), 1)
  expect_equal(unmatched_lookup_results(lookup_results)$query_arg, "unknownARG")
})

testthat::test_that("lookup summary reports counts and match rate", {
  lookup_results <- data.frame(
    query_arg = c("sul1", "blaTEM", "unknownARG"),
    matched_status = c("Matched", "Matched", "Unmatched"),
    stringsAsFactors = FALSE
  )

  summary <- lookup_summary(lookup_results)

  expect_equal(summary$total_queries, 3)
  expect_equal(summary$matched_queries, 2)
  expect_equal(summary$unmatched_queries, 1)
  expect_equal(summary$match_rate_percent, 66.7)
})
