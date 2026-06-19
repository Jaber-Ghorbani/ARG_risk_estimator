library(testthat)

testthat::test_dir(
  path = file.path("tests", "testthat"),
  reporter = "summary"
)
