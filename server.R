library(shiny)
load("geneSet2.RData")
library(ggplot2)
library(gridExtra)
library(grid)
library(RColorBrewer)
library(shinyBS)



bulkRNAseq <- function(input) {
  #read file
  dataset <-
    as.matrix(read.table(
      file.path("data", input$dataset, "data.txt"),
      sep = "\t",
      header = TRUE,
      row.names = 1
    ))
  samp.f <- as.matrix(read.table(
    file.path("data", input$dataset, "sampleInfo.txt"),
    sep = "\t",
    header = TRUE
  ))
  samp.f <- samp.f[, 2]
  samp.f <- factor(samp.f, levels = unique(samp.f), ordered = TRUE)
  #plot row
  gene <- sub(" - .*", "", isolate(input$gene))
  if (!is.na(match(gene, rownames(dataset)))) {
    theme_set(theme_bw())
    df <- list()
    df$y <- dataset[gene, ]
    df$x <- 1:length(df$y)
    df$col <- samp.f
    df <- as.data.frame(df)
    p <- ggplot(df, aes(
      x = col,
      y = y,
      color = col,
      ymin = mean(y),
      ymax = mean(y)
    )) +
      scale_color_discrete() +
      guides(fill = FALSE) +  theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      ) +
      geom_pointrange(size = 2) + ylab("Transformed Counts") +
      ggtitle("BulkRNAseq") + theme(text = element_text(size = 20))
    print(p)
  }
  else{
    grid.text(label = paste("Gene:", gene, "is bellow threshold"))
  }
}

shinyServer(function(input, output, session) {
  observeEvent(input$reset, {
                 print(input$reset)
                 updateTypeAhead(session, inputId = "gene", value = "")
               })
  observeEvent(input$plot, {
                 output$bulkRNAseq <- renderPlot(bulkRNAseq(input))
               })
  updateTypeAhead(session,
                  inputId = "gene",
                  label = "Look up gene (Human symbol):",
                  choices = geneSet2)
})
