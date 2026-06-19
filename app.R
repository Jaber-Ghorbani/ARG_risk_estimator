# ARG Risk & Abundance-Informed Index Tool

library(shiny)
library(bslib)
library(dplyr)
library(readr)
library(stringr)
library(tibble)
library(DT)
library(ggplot2)

source("R/input_validation.R")
source("R/score_lookup.R")
source("R/index_calculation.R")
source("R/plots.R")
source("R/report_download.R")

private_score_path <- Sys.getenv("ARG_SCORE_DB_PATH", "data_private/arg_scores_clean.csv")

demo_score_database <- function() {
  tibble::tribble(
    ~ARG, ~arg_family, ~drug_class, ~clinical_score, ~mobility_score, ~pathogenic_score, ~transmissibility_score, ~final_hc_score, ~criteria_complete,
    "sul1", "sul", "sulfonamide", 0.43, 0.72, 0.31, 0.54, 0.50, TRUE,
    "tetM", "tet", "tetracycline", 0.43, 0.66, 0.28, 0.42, 0.45, TRUE,
    "intI1", "integron", "indicator", 0.20, 0.90, 0.22, 0.60, 0.47, TRUE,
    "blaTEM", "bla", "beta-lactam", 1.00, 0.68, 0.55, 0.58, 0.71, TRUE,
    "qnrS", "qnr", "fluoroquinolone", 1.00, 0.74, 0.46, 0.52, 0.69, TRUE,
    "ermB", "erm", "macrolide", 0.77, 0.70, 0.38, 0.50, 0.60, TRUE
  ) |>
    mutate(
      normalized_arg_name = normalize_arg_name(ARG),
      final_hc_score_percent = final_hc_score * 100,
      criteria_completeness = if_else(criteria_complete, "Complete demo record", "Incomplete demo record"),
      data_source = "synthetic_demo"
    )
}

load_score_database <- function(path = private_score_path) {
  if (file.exists(path)) {
    dat <- readr::read_csv(path, show_col_types = FALSE)
    list(data = dat, mode = "private")
  } else if (file.exists("public_examples/demo_score_table.csv")) {
    dat <- readr::read_csv("public_examples/demo_score_table.csv", show_col_types = FALSE)
    list(data = dat, mode = "demo")
  } else {
    list(data = demo_score_database(), mode = "demo")
  }
}

example_dataset <- function() {
  tibble::tribble(
    ~SampleID, ~ARG, ~Abundance,
    "Sample_1", "sul1", 1200,
    "Sample_1", "tetM", 450,
    "Sample_1", "unknownARG_demo", 90,
    "Sample_2", "blaTEM", 85,
    "Sample_2", "qnrS", 160,
    "Sample_3", "ermB", 310,
    "Sample_3", "intI1", 700
  )
}

interpretation_note <- div(
  class = "arg-warning",
  strong("Important interpretation note: "),
  "The final ARG hazard score is a relative prioritization metric. It is not a direct clinical infection-risk estimate, regulatory threshold, diagnostic result, or substitute for exposure assessment. Compare abundance-informed index values only among samples analyzed with the same abundance unit and normalization method."
)

ui <- bslib::page_navbar(
  title = "ARG Risk & Abundance-Informed Index Tool",
  theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
  header = tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),

  bslib::nav_panel(
    "Overview",
    div(
      class = "arg-hero",
      h1("ARG Risk & Abundance-Informed Index Tool"),
      p("From ARG detection to risk-informed prioritization.")
    ),
    div(
      class = "arg-card",
      h3("Purpose"),
      p("This Shiny application supports ARG hazard-score lookup and abundance-informed sample indexing for environmental and One Health AMR datasets."),
      div(class = "arg-formula", "ARG contribution = ARG abundance × final ARG hazard score"),
      br(),
      div(class = "arg-formula", "Sample-level abundance-informed index = sum(ARG contribution)")
    ),
    interpretation_note
  ),

  bslib::nav_panel(
    "ARG Lookup",
    layout_sidebar(
      sidebar = sidebar(
        textAreaInput("lookup_text", "Enter ARG names", value = "sul1\ntetM\nblaTEM\nunknownARG_demo", rows = 8),
        actionButton("run_lookup", "Run lookup", class = "btn-primary"),
        br(), br(),
        downloadButton("download_lookup", "Download lookup results")
      ),
      div(class = "arg-card", h4("Lookup summary"), DTOutput("lookup_summary")),
      div(class = "arg-card", h4("Lookup results"), DTOutput("lookup_table")),
      interpretation_note
    )
  ),

  bslib::nav_panel(
    "Dataset Index",
    layout_sidebar(
      sidebar = sidebar(
        fileInput("upload_file", "Upload CSV", accept = ".csv"),
        checkboxInput("use_example", "Use built-in example dataset", value = TRUE),
        actionButton("run_dataset", "Calculate index", class = "btn-primary"),
        br(), br(),
        downloadButton("download_sample", "Download sample index"),
        downloadButton("download_gene", "Download gene contributions"),
        downloadButton("download_unmatched", "Download unmatched ARGs")
      ),
      div(class = "arg-card", h4("Sample-level index"), DTOutput("sample_index_table")),
      div(class = "arg-card", h4("Top contributors"), plotOutput("top_contributors_plot", height = "420px")),
      div(class = "arg-card", h4("Gene-level contributions"), DTOutput("gene_contribution_table")),
      div(class = "arg-card", h4("Unmatched ARGs"), DTOutput("unmatched_table")),
      interpretation_note
    )
  ),

  bslib::nav_panel(
    "Methods",
    div(class = "arg-card", h3("Hazard-score formula"), div(class = "arg-formula", "Final score = 0.284 × Clinical relevance + 0.256 × Mobility + 0.248 × Pathogenic potential + 0.212 × Inter-environment transmissibility")),
    div(class = "arg-card", h3("Matching"), p("ARG names are normalized by trimming spaces, converting to lowercase, and removing punctuation before matching.")),
    interpretation_note
  ),

  bslib::nav_panel(
    "About",
    div(class = "arg-card", h3("Development team"), p("Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, University of Nebraska–Lincoln. Advisor: Dr. Bing Wang.")),
    div(class = "arg-card", h3("Data-release policy"), p("The public repository contains code, documentation, templates, and synthetic examples. The full ARG score database is not included in the public repository."))
  )
)

server <- function(input, output, session) {
  score_bundle <- load_score_database()
  score_db <- score_bundle$data

  observe({
    if (identical(score_bundle$mode, "demo")) {
      showNotification("Demo score table loaded. Full private score database was not found in this environment.", type = "warning", duration = 8)
    }
  })

  lookup_results <- eventReactive(input$run_lookup, {
    lookup_arg_scores(input$lookup_text, score_db)
  }, ignoreInit = FALSE)

  output$lookup_summary <- renderDT({
    datatable(lookup_summary(lookup_results()), rownames = FALSE, options = list(dom = "t"))
  })

  output$lookup_table <- renderDT({
    datatable(lookup_results(), rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  })

  uploaded_data <- eventReactive(input$run_dataset, {
    if (isTRUE(input$use_example) || is.null(input$upload_file)) {
      dat <- example_dataset()
    } else {
      dat <- readr::read_csv(input$upload_file$datapath, show_col_types = FALSE)
    }
    valid <- validate_upload_data(dat)
    validate(need(isTRUE(valid$valid), valid$message))
    valid$data
  }, ignoreInit = FALSE)

  dataset_results <- reactive({
    analyze_uploaded_dataset(uploaded_data(), score_db)
  })

  output$sample_index_table <- renderDT({
    datatable(dataset_results()$sample_index, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  })

  output$gene_contribution_table <- renderDT({
    datatable(dataset_results()$gene_contributions, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  })

  output$unmatched_table <- renderDT({
    datatable(dataset_results()$unmatched_args, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  })

  output$top_contributors_plot <- renderPlot({
    make_top_contributors_plot(dataset_results()$gene_contributions, n = 15)
  })

  output$download_lookup <- downloadHandler(
    filename = function() "arg_lookup_results.csv",
    content = function(file) write_output_csv(prepare_lookup_output(lookup_results()), file)
  )

  output$download_sample <- downloadHandler(
    filename = function() "sample_abundance_informed_index.csv",
    content = function(file) write_output_csv(prepare_sample_output(dataset_results()$sample_index), file)
  )

  output$download_gene <- downloadHandler(
    filename = function() "arg_gene_contributions.csv",
    content = function(file) write_output_csv(prepare_gene_output(dataset_results()$gene_contributions), file)
  )

  output$download_unmatched <- downloadHandler(
    filename = function() "unmatched_args.csv",
    content = function(file) write_output_csv(prepare_unmatched_output(dataset_results()$unmatched_args), file)
  )
}

shinyApp(ui, server)
