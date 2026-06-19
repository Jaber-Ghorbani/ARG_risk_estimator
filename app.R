# ARG Risk & Abundance-Informed Index Tool
# Public Shiny application skeleton

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

make_demo_score_database <- function() {
  tibble::tribble(
    ~ARG, ~drug_class, ~clinical_score, ~mobility_score, ~pathogenic_score, ~transmissibility_score, ~final_hc_score, ~criteria_complete,
    "sul1", "sulfonamide", 0.43, 0.72, 0.31, 0.54, 0.50, TRUE,
    "tetM", "tetracycline", 0.43, 0.66, 0.28, 0.42, 0.45, TRUE,
    "intI1", "integron indicator", 0.20, 0.90, 0.22, 0.60, 0.47, TRUE,
    "blaTEM", "beta-lactam", 1.00, 0.68, 0.55, 0.58, 0.71, TRUE,
    "qnrS", "fluoroquinolone", 1.00, 0.74, 0.46, 0.52, 0.69, TRUE,
    "ermB", "macrolide", 0.77, 0.70, 0.38, 0.50, 0.60, TRUE
  ) |>
    mutate(
      normalized_arg_name = normalize_arg_name(ARG),
      final_hc_score_percent = final_hc_score * 100,
      data_source = "synthetic_demo"
    )
}

load_score_database <- function(path = private_score_path) {
  if (file.exists(path)) {
    raw_scores <- readr::read_csv(path, show_col_types = FALSE)
    score_db <- prepare_score_database(raw_scores)
    list(data = score_db, demo_mode = FALSE)
  } else {
    score_db <- prepare_score_database(make_demo_score_database())
    list(data = score_db, demo_mode = TRUE)
  }
}

score_bundle <- load_score_database()
score_db <- score_bundle$data
app_demo_mode <- score_bundle$demo_mode

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#8C1D40",
  secondary = "#13294B",
  base_font = font_google("Inter"),
  heading_font = font_google("Inter")
)

ui <- page_navbar(
  title = "ARG Risk & Index Tool",
  theme = app_theme,
  header = tagList(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  nav_panel(
    "Overview",
    div(
      class = "hero-panel",
      h1("ARG Risk & Abundance-Informed Index Tool"),
      p("A research-based platform for prioritizing antimicrobial resistance genes across environmental and One Health datasets."),
      tags$span(class = "hero-tag", "From ARG detection to risk-informed prioritization")
    ),
    layout_columns(
      col_widths = c(4, 4, 4),
      value_box("Score database", nrow(score_db), showcase = bsicons::bs_icon("database")),
      value_box("Score range", "0–1", showcase = bsicons::bs_icon("speedometer")),
      value_box("Index formula", "Abundance × HC score", showcase = bsicons::bs_icon("calculator"))
    ),
    card(
      card_header("What this tool does"),
      p("The app allows users to look up ARG hazard scores and calculate an abundance-informed index for user-provided datasets."),
      p("The abundance-informed index is calculated by multiplying each matched ARG abundance by its hazard characterization score and summing contributions by sample."),
      if (app_demo_mode) {
        div(class = "note-box", "Demo mode is active because the private score database is not present in this public repository.")
      }
    ),
    card(
      card_header("Recommended workflow"),
      tags$ol(
        tags$li("Enter ARG names manually or upload a CSV dataset."),
        tags$li("Review matched and unmatched ARGs."),
        tags$li("Use the score table to prioritize individual ARGs."),
        tags$li("Use the sample index to compare samples analyzed with the same abundance unit and normalization method.")
      )
    )
  ),

  nav_panel(
    "ARG Lookup",
    layout_sidebar(
      sidebar = sidebar(
        textAreaInput(
          "lookup_text",
          "Enter ARG names",
          value = "sul1\ntetM\nblaTEM",
          rows = 8,
          placeholder = "One ARG per line, or comma-separated"
        ),
        actionButton("run_lookup", "Run lookup", class = "btn-primary"),
        hr(),
        downloadButton("download_lookup", "Download matched lookup")
      ),
      card(
        card_header("Matched ARG scores"),
        DTOutput("lookup_table")
      ),
      card(
        card_header("Unmatched ARGs"),
        DTOutput("lookup_unmatched")
      )
    )
  ),

  nav_panel(
    "Dataset Index",
    layout_sidebar(
      sidebar = sidebar(
        fileInput("dataset_file", "Upload CSV dataset", accept = ".csv"),
        helpText("Required columns: SampleID, ARG, Abundance"),
        checkboxInput("use_example", "Use built-in example dataset", value = TRUE),
        actionButton("run_dataset", "Analyze dataset", class = "btn-primary"),
        hr(),
        downloadButton("download_sample_index", "Download sample index"),
        downloadButton("download_gene_contrib", "Download gene contributions")
      ),
      card(
        card_header("Sample-level abundance-informed index"),
        DTOutput("sample_index_table")
      ),
      card(
        card_header("Top ARG contributors"),
        plotOutput("top_contributors_plot", height = "420px")
      ),
      card(
        card_header("Matched gene contributions"),
        DTOutput("gene_contrib_table")
      ),
      card(
        card_header("Unmatched uploaded ARGs"),
        DTOutput("dataset_unmatched_table")
      )
    )
  ),

  nav_panel(
    "Methods",
    card(
      card_header("Hazard-characterization score"),
      p("The final score combines clinical relevance, mobility, pathogenic potential, and inter-environment transmissibility."),
      tags$pre("Final HC score = 0.284 × Clinical + 0.256 × Mobility + 0.248 × Pathogenic potential + 0.212 × Inter-environment transmissibility")
    ),
    card(
      card_header("Abundance-informed index"),
      tags$pre("ARG contribution = ARG abundance × final HC score\nSample index = Σ(ARG contribution)"),
      p("This index is intended for relative comparison among samples generated using compatible abundance measurements.")
    )
  ),

  nav_panel(
    "About",
    card(
      card_header("Development"),
      p("Developed by Jaber Ghorbani, Food Safety & Food Microbiology Lab, University of Nebraska–Lincoln."),
      p("Advisor: Dr. Bing Wang."),
      p("This public repository contains app code, documentation, templates, and synthetic examples. The full score database is handled separately for deployment.")
    )
  )
)

server <- function(input, output, session) {
  lookup_results <- eventReactive(input$run_lookup, {
    arg_names <- parse_lookup_args(input$lookup_text)
    req(length(arg_names) > 0)
    lookup_arg_scores(arg_names, score_db)
  }, ignoreInit = FALSE)

  output$lookup_table <- renderDT({
    matched <- matched_lookup_results(lookup_results())
    DT::datatable(matched, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
  })

  output$lookup_unmatched <- renderDT({
    unmatched <- unmatched_lookup_results(lookup_results())
    DT::datatable(unmatched, options = list(pageLength = 10), rownames = FALSE)
  })

  output$download_lookup <- downloadHandler(
    filename = function() paste0("arg_score_lookup_", Sys.Date(), ".csv"),
    content = function(file) {
      write_output_csv(prepare_lookup_output(matched_lookup_results(lookup_results())), file)
    }
  )

  example_dataset <- reactive({
    tibble::tribble(
      ~SampleID, ~ARG, ~Abundance, ~Unit, ~Matrix,
      "SurfaceWater_A", "sul1", 1200, "copies/mL", "Surface water",
      "SurfaceWater_A", "tetM", 450, "copies/mL", "Surface water",
      "SurfaceWater_A", "intI1", 900, "copies/mL", "Surface water",
      "Wastewater_B", "blaTEM", 85, "copies/mL", "Wastewater",
      "Wastewater_B", "sul1", 3000, "copies/mL", "Wastewater",
      "Wastewater_B", "qnrS", 350, "copies/mL", "Wastewater",
      "Wastewater_B", "unknownARG_demo", 75, "copies/mL", "Wastewater"
    )
  })

  uploaded_dataset <- reactive({
    if (isTRUE(input$use_example) || is.null(input$dataset_file)) {
      example_dataset()
    } else {
      readr::read_csv(input$dataset_file$datapath, show_col_types = FALSE)
    }
  })

  dataset_results <- eventReactive(input$run_dataset, {
    dat <- uploaded_dataset()
    validation <- validate_upload_data(dat)
    validate(need(isTRUE(validation$valid), validation$message))
    analyze_uploaded_dataset(dat, score_db)
  }, ignoreInit = FALSE)

  output$sample_index_table <- renderDT({
    DT::datatable(dataset_results()$sample_index, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
  })

  output$gene_contrib_table <- renderDT({
    DT::datatable(dataset_results()$gene_contributions, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
  })

  output$dataset_unmatched_table <- renderDT({
    DT::datatable(dataset_results()$unmatched, options = list(pageLength = 10, scrollX = TRUE), rownames = FALSE)
  })

  output$top_contributors_plot <- renderPlot({
    make_top_contributors_plot(dataset_results()$gene_contributions, n = 10)
  })

  output$download_sample_index <- downloadHandler(
    filename = function() paste0("sample_abundance_informed_index_", Sys.Date(), ".csv"),
    content = function(file) {
      write_output_csv(prepare_sample_output(dataset_results()$sample_index), file)
    }
  )

  output$download_gene_contrib <- downloadHandler(
    filename = function() paste0("arg_gene_contributions_", Sys.Date(), ".csv"),
    content = function(file) {
      write_output_csv(prepare_gene_output(dataset_results()$gene_contributions), file)
    }
  )
}

shinyApp(ui, server)
