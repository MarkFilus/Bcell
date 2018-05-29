.libPaths("/home/mchikina/R/x86_64-pc-linux-gnu-library/3.1")
load("BcellShiny.RData")
load("GCmiSeq.RData")
load("geneSet.RData")
library(shiny)
library(shinyBS)
library(shinybootstrap2)
shinybootstrap2::withBootstrap2({
shinyUI(fluidPage(
  
  # This is the variable containing the source for the typeahead. It has been truncated to save space.
  sidebarLayout(
    sidebarPanel(
  bsTypeAhead(inputId = "gene", label = "Look up gene (Human symbol):", value="CD19",choices = geneSet),
  submitButton("Plot Gene"),
  tags$small(paste(
    "The suggested genes are those for which we have some data. ",
    "Genes are missing if they were not detected in more than 10 samples (RNAseq), ",
    "were bellow the detection theshold on the Illumina array, ",
    "or had no probes on the array.", sep="\n"
  ))
    ),
  mainPanel(
    fluidRow(
column(width=5,plotOutput("plotGCmiseq", width=450, height = 350)),
    column(width=5, offset = 1,plotOutput("plotGC", width=450, height = 350))),
    fluidRow(
    column(width=6,plotOutput("plotRS", width=600, height = 350)),
    column(width=6,plotOutput("plotSubset", width=450, height = 350))
    ))
)))
  

})