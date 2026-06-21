# ARG Abundance-Informed HC Index Tool

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
reference_water_path <- "public_examples/figure4_water_benchmark.csv"

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

template_dataset <- function() {
  tibble::tribble(
    ~SampleID, ~ARG, ~Abundance,
    "Sample_1", "sul1", 1200,
    "Sample_1", "tetM", 450,
    "Sample_2", "blaTEM", 85
  )
}

reference_water_benchmark <- function(path = reference_water_path) {
  if (file.exists(path)) {
    readr::read_csv(path, show_col_types = FALSE)
  } else {
    tibble::tribble(
      ~Environment, ~Environment_Label, ~Samples, ~Mean_Index, ~Median_Index, ~Min_Index, ~Max_Index, ~SD_Index,
      "Hospital", "Hospital wastewater", 15, 829.299538, 850.271757, 600.049993, 1049.150764, 139.064287,
      "Wastewater", "Wastewater treatment samples", 26, 147.674251, 131.770403, 22.658543, 393.568547, 104.626392,
      "Drinking", "Drinking water", 8, 27.825208, 22.359404, 12.485955, 62.820821, 15.867681,
      "Lake", "Lake water", 11, 9.307640, 11.124215, 0.744139, 21.413478, 6.707532,
      "River", "River water", 8, 6.064697, 5.323411, 1.368174, 12.009295, 3.950899,
      "Sea", "Sea water", 25, 0.682791, 0.382010, 0.000000, 2.294578, 0.703389
    )
  }
}

nearest_reference_value <- function(x, reference_data, field) {
  if (is.na(x) || nrow(reference_data) == 0) return(NA)
  idx <- which.min(abs(x - reference_data$Mean_Index))
  reference_data[[field]][idx]
}

compare_to_reference <- function(sample_index_data, reference_data) {
  if (!is.data.frame(sample_index_data) || nrow(sample_index_data) == 0) {
    return(sample_index_data)
  }

  reference_data <- reference_data |>
    filter(!is.na(.data$Mean_Index)) |>
    arrange(desc(.data$Mean_Index))

  sample_index_data |>
    rowwise() |>
    mutate(
      nearest_reference_group = nearest_reference_value(.data$abundance_informed_index, reference_data, "Environment_Label"),
      nearest_reference_mean_index = nearest_reference_value(.data$abundance_informed_index, reference_data, "Mean_Index")
    ) |>
    ungroup()
}

make_reference_water_plot <- function(reference_data) {
  plot_data <- reference_data |>
    mutate(
      Environment_Label = factor(
        .data$Environment_Label,
        levels = .data$Environment_Label[order(.data$Mean_Index)]
      ),
      lower = pmax(0, .data$Mean_Index - .data$SD_Index),
      upper = .data$Mean_Index + .data$SD_Index
    )

  ggplot(plot_data, aes(x = .data$Environment_Label, y = .data$Mean_Index)) +
    geom_col(width = 0.72, fill = "#7a0019") +
    geom_errorbar(aes(ymin = .data$lower, ymax = .data$upper), width = 0.20) +
    coord_flip() +
    labs(
      title = "Reference water-sample comparison",
      subtitle = "Mean abundance-informed HC index by water-sample group",
      x = NULL,
      y = "Mean abundance-informed HC index"
    ) +
    theme_minimal(base_size = 13)
}

interpretation_note <- div(
  class = "arg-warning",
  strong("Interpretation note: "),
  "The abundance-informed HC index is a relative prioritization metric. Compare values only among samples analyzed with the same abundance unit and normalization method. Unmatched ARGs are excluded from the calculated index and should be reviewed separately."
)

data_policy_note <- div(
  class = "arg-note",
  strong("Public data policy: "),
  "The public GitHub repository contains app code, templates, synthetic examples, and summary-level reference benchmarks. The full ARG score database is loaded server-side and is not released in this repository."
)

ui <- bslib::page_navbar(
  title = "ARG Abundance-Informed HC Index",
  theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
  header = tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),

  bslib::nav_panel(
    "Home",
    div(
      class = "arg-hero",
      h1("ARG Abundance-Informed HC Index Tool"),
      p("A simple Shiny app for comparing ARG abundance profiles using a hazard-characterization score.")
    ),
    div(
      class = "arg-card",
      h3("What the tool calculates"),
      p("The app combines ARG abundance with ARG hazard-characterization scores to produce a sample-level abundance-informed HC index."),
      div(class = "arg-formula", "ARG contribution = ARG abundance × final HC score"),
      br(),
      div(class = "arg-formula", "Sample-level abundance-informed HC index = Σ(ARG contribution)")
    ),
    div(
      class = "arg-card",
      h3("How users should use it"),
      tags$ol(
        tags$li("Paste ARG names to check whether scores are available."),
        tags$li("Upload a CSV file with SampleID, ARG, and Abundance columns."),
        tags$li("Review sample-level index values and top ARG contributors."),
        tags$li("Compare the resulting index with the reference water-sample benchmarks.")
      )
    ),
    data_policy_note,
    interpretation_note
  ),

  bslib::nav_panel(
    "ARG lookup",
    layout_sidebar(
      sidebar = sidebar(
        textAreaInput(
          "lookup_text",
          "Enter ARG names",
          value = "sul1\ntetM\nblaTEM\nunknownARG_demo",
          rows = 8
        ),
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
    "Calculate index",
    layout_sidebar(
      sidebar = sidebar(
        fileInput("upload_file", "Upload CSV", accept = ".csv"),
        checkboxInput("use_example", "Use built-in example dataset", value = TRUE),
        actionButton("run_dataset", "Calculate index", class = "btn-primary"),
        br(), br(),
        downloadButton("download_template", "Download CSV template"),
        downloadButton("download_sample", "Download sample index"),
        downloadButton("download_gene", "Download gene contributions"),
        downloadButton("download_unmatched", "Download unmatched ARGs")
      ),
      div(
        class = "arg-card",
        h4("Sample-level index"),
        p(class = "arg-muted", "The nearest reference group is based on the closest mean reference value. This comparison is only meaningful when abundance units and normalization are compatible."),
        DTOutput("sample_index_table")
      ),
      div(class = "arg-card", h4("Sample index plot"), plotOutput("sample_index_plot", height = "360px")),
      div(class = "arg-card", h4("Top ARG contributors"), plotOutput("top_contributors_plot", height = "420px")),
      div(class = "arg-card", h4("Gene-level contributions"), DTOutput("gene_contribution_table")),
      div(class = "arg-card", h4("Unmatched ARGs"), DTOutput("unmatched_table")),
      interpretation_note
    )
  ),

  bslib::nav_panel(
    "Reference waters",
    div(
      class = "arg-card",
      h3("Figure 4-style reference comparison"),
      p("This benchmark plot summarizes abundance-informed HC index values across water-sample groups from the manuscript validation analysis. It is included so users can compare their calculated sample values against a fixed reference context.")
    ),
    div(class = "arg-card", plotOutput("reference_water_plot", height = "430px")),
    div(class = "arg-card", h4("Reference benchmark table"), DTOutput("reference_water_table")),
    interpretation_note
  ),

  bslib::nav_panel(
    "Methods",
    div(
      class = "arg-card",
      h3("Score formula"),
      p("The final HC score integrates four weighted criteria: clinical relevance, mobility, pathogenic potential, and inter-environment transmissibility."),
      div(class = "arg-formula", "Final HC score = 0.284 × Clinical relevance + 0.256 × Mobility + 0.248 × Pathogenic potential + 0.212 × Inter-environment transmissibility")
    ),
    div(
      class = "arg-card",
      h3("ARG matching"),
      p("ARG names are normalized by trimming spaces, converting to lowercase, and removing punctuation before matching.")
    ),
    div(
      class = "arg-card",
      h3("Index calculation"),
      p("For matched ARGs, each ARG contribution is calculated as abundance multiplied by the final HC score. Sample-level values are then summed.")
    ),
    data_policy_note,
    interpretation_note
  )
)

server <- function(input, output, session) {
  score_bundle <- load_score_database()
  score_db <- score_bundle$data
  reference_data <- reference_water_benchmark()

  observe({
    if (identical(score_bundle$mode, "demo")) {
      showNotification(
        "Demo score table loaded. Full private score database was not found in this environment.",
        type = "warning",
        duration = 8
      )
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
    datatable(
      compare_to_reference(dataset_results()$sample_index, reference_data),
      rownames = FALSE,
      options = list(pageLength = 10, scrollX = TRUE)
    )
  })

  output$sample_index_plot <- renderPlot({
    make_sample_index_plot(dataset_results()$sample_index)
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

  output$reference_water_plot <- renderPlot({
    make_reference_water_plot(reference_data)
  })

  output$reference_water_table <- renderDT({
    datatable(
      reference_data |>
        arrange(.data$Rank) |>
        mutate(across(where(is.numeric), ~ round(.x, 3))),
      rownames = FALSE,
      options = list(pageLength = 6, scrollX = TRUE)
    )
  })

  output$download_lookup <- downloadHandler(
    filename = function() "arg_lookup_results.csv",
    content = function(file) write_output_csv(prepare_lookup_output(lookup_results()), file)
  )

  output$download_template <- downloadHandler(
    filename = function() "arg_abundance_template.csv",
    content = function(file) readr::write_csv(template_dataset(), file)
  )

  output$download_sample <- downloadHandler(
    filename = function() "sample_abundance_informed_hc_index.csv",
    content = function(file) write_output_csv(prepare_sample_output(compare_to_reference(dataset_results()$sample_index, reference_data)), file)
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
