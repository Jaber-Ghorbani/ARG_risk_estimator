library(testthat)
library(dplyr)
library(readr)
library(stringr)
library(tibble)
library(ggplot2)

source("R/input_validation.R")
source("R/score_lookup.R")
source("R/index_calculation.R")
source("R/plots.R")
source("R/report_download.R")

testthat::test_dir(
  path = file.path("tests", "testthat"),
  reporter = "summary"
)
