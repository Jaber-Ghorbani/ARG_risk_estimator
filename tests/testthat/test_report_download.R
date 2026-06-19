testthat::test_that("output table helpers work", {
  tbl <- data.frame(ARG = "sul1", final_hc_score = 0.42)
  expect_true(is.data.frame(as_output_table(NULL)))
  expect_equal(nrow(as_output_table(tbl)), 1)
  expect_equal(nrow(empty_output_message("No records")), 1)
  expect_equal(nrow(prepare_lookup_output(tbl)), 1)
  expect_equal(nrow(prepare_sample_output(tbl)), 1)
  expect_equal(nrow(prepare_gene_output(tbl)), 1)
  expect_equal(nrow(prepare_unmatched_output(tbl)), 1)
})

testthat::test_that("write_output_csv writes a CSV file", {
  output_path <- tempfile(fileext = ".csv")
  tbl <- data.frame(ARG = "sul1", final_hc_score = 0.42)
  result_path <- write_output_csv(tbl, output_path)
  expect_true(file.exists(result_path))
  imported <- read.csv(result_path)
  expect_equal(imported$ARG[[1]], "sul1")
})
