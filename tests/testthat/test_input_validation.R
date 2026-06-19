testthat::test_that("normalize_arg_name standardizes common ARG labels", {
  testthat::expect_equal(normalize_arg_name(" sul-1 "), "sul1")
  testthat::expect_equal(normalize_arg_name("bla TEM"), "blatem")
  testthat::expect_equal(normalize_arg_name("tet_M"), "tetm")
  testthat::expect_equal(normalize_arg_name(NULL), character(0))
})

testthat::test_that("parse_lookup_args handles separated lookup text", {
  parsed <- parse_lookup_args("sul1, tetM; blaTEM\nqnrS")

  testthat::expect_equal(nrow(parsed), 4)
  testthat::expect_true(all(c("ARG", "normalized_arg_name") %in% names(parsed)))
  testthat::expect_equal(parsed$normalized_arg_name, c("sul1", "tetm", "blatem", "qnrs"))
})

testthat::test_that("validate_lookup_input rejects blank input", {
  result <- validate_lookup_input("   ")

  testthat::expect_false(result$valid)
  testthat::expect_equal(nrow(result$data), 0)
  testthat::expect_match(result$message, "Enter at least one ARG")
})

testthat::test_that("validate_lookup_input accepts non-empty ARG input", {
  result <- validate_lookup_input("sul1, tetM")

  testthat::expect_true(result$valid)
  testthat::expect_equal(nrow(result$data), 2)
  testthat::expect_equal(result$message, "Lookup input is valid.")
})

testthat::test_that("validate_upload_data requires SampleID ARG and Abundance columns", {
  dat <- data.frame(SampleID = "Sample_1", ARG = "sul1")
  result <- validate_upload_data(dat)

  testthat::expect_false(result$valid)
  testthat::expect_match(result$message, "Missing required column")
})

testthat::test_that("validate_upload_data rejects blank SampleID values", {
  dat <- data.frame(SampleID = "", ARG = "sul1", Abundance = 10)
  result <- validate_upload_data(dat)

  testthat::expect_false(result$valid)
  testthat::expect_match(result$message, "SampleID contains missing or blank")
})

testthat::test_that("validate_upload_data rejects blank ARG values", {
  dat <- data.frame(SampleID = "Sample_1", ARG = "", Abundance = 10)
  result <- validate_upload_data(dat)

  testthat::expect_false(result$valid)
  testthat::expect_match(result$message, "ARG contains missing or blank")
})

testthat::test_that("validate_upload_data rejects non-numeric abundance", {
  dat <- data.frame(SampleID = "Sample_1", ARG = "sul1", Abundance = "not_a_number")
  result <- validate_upload_data(dat)

  testthat::expect_false(result$valid)
  testthat::expect_match(result$message, "Abundance must be numeric")
})

testthat::test_that("validate_upload_data rejects negative abundance", {
  dat <- data.frame(SampleID = "Sample_1", ARG = "sul1", Abundance = -1)
  result <- validate_upload_data(dat)

  testthat::expect_false(result$valid)
  testthat::expect_match(result$message, "non-negative")
})

testthat::test_that("validate_upload_data accepts valid upload data", {
  dat <- data.frame(
    SampleID = c("Sample_1", "Sample_1", "Sample_2"),
    ARG = c("sul1", "tetM", "bla TEM"),
    Abundance = c(100, 25.5, "8")
  )
  result <- validate_upload_data(dat)

  testthat::expect_true(result$valid)
  testthat::expect_true("normalized_arg_name" %in% names(result$data))
  testthat::expect_equal(result$data$normalized_arg_name, c("sul1", "tetm", "blatem"))
  testthat::expect_equal(result$message, "Uploaded dataset is valid.")
})

testthat::test_that("validation_message returns message or empty string", {
  testthat::expect_equal(validation_message(list(message = "OK")), "OK")
  testthat::expect_equal(validation_message(list()), "")
})
