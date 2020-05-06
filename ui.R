library(shiny)
load("geneSet2.RData")
library(shiny)
library(shinyBS)
library(shinybootstrap2)

shinybootstrap2::withBootstrap2({
  shinyUI(fluidPage(# This is the variable containing the source for the typeahead.
                    # It has been truncated to save space.
    sidebarLayout(
      sidebarPanel(
        bsTypeAhead(
          inputId = "gene",
          label = "Look up gene (Human symbol):",
          value = "CD19",
          choices = geneSet2
        ),
        selectInput(
          inputId = "dataset",
          label = "Dataset",
          choices = basename(list.dirs(path = "data", recursive = FALSE))
        ),
        tags$br(),
        actionButton("plot", "Plot Gene"),
        tags$br(),
        actionButton("reset", "Reset input"),
        tags$br(),
        tags$small(
          paste(
            "The suggested genes are those for which we have some data. ",
            "Genes are missing if they were not detected in more than 10 samples (RNAseq), ",
            "were bellow the detection theshold on the Illumina array, ",
            "or had no probes on the array.",
            sep = "\n"
          )
        )
      ),
      mainPanel(fluidRow(column(
        width = 12, plotOutput("bulkRNAseq", width = "100%")
      )))
    )))
})
