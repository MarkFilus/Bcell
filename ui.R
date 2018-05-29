#.libPaths("/home/mchikina/R/x86_64-pc-linux-gnu-library/3.4","/home/mchikina/R/x86_64-pc-linux-gnu-library/3.1")
#load("BcellShinyUpdate.RData")
#load("GCmiSeq.RData")
#load("newRNAseq.RData")
#load("geneSet.RData")
load("geneSet2.RData")
#library(shiny)
#library(shinyBS)
#library(shinybootstrap2)
#shinybootstrap2::withBootstrap2({
shinyUI(fluidPage(
  
  # This is the variable containing the source for the typeahead. It has been truncated to save space.
  sidebarLayout(
    sidebarPanel(
  bsTypeAhead(inputId = "gene", label = "Look up gene (Human symbol):", value="CD19",choices = geneSet2),tags$br(),
  actionButton("plot", "Plot Gene"), tags$br(),
  actionButton("reset", "Reset input"),tags$br(),
  tags$small(paste(
    "The suggested genes are those for which we have some data. ",
    "Genes are missing if they were not detected in more than 10 samples (RNAseq), ",
    "were bellow the detection theshold on the Illumina array, ",
    "or had no probes on the array.", sep="\n"
  ))
    ),
  mainPanel(
    fluidRow(
#column(width=12,plotOutput("plotGCmiseq", width="100%"))),
   
    fluidRow(
  #    column(width=5, plotOutput("plotGC")),
    #column(width=6,plotOutput("plotRS", width=600, height = 350)),
 #   column(width=5,plotOutput("plotSubset"))
    ),
#fluidRow(plotOutput("plotSplicing")),
#fluidRow(tags$small(""))

)
)))
  

#})