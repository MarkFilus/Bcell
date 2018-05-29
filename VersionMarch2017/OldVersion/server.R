.libPaths("/home/mchikina/R/x86_64-pc-linux-gnu-library/3.1")
load("BcellShiny.RData")
load("GCmiSeq.RData")
load("geneSet.RData")
library(ggplot2)
library(gridExtra)
#source("help.R")


library(shiny)
library(shinyBS)


plotRS=function(input){
  if (! is.na(match(input$gene, rownames(data)))){
    theme_set(theme_bw())
    df=list()
    
    df$y=data[input$gene,]
    df$x=1:ncol(data)
    df$col=facts
    df$pop=pop
    df=as.data.frame(df)
    p<-ggplot(df, aes(x=x,y=y, color=col, shape=pop))+geom_point(size=5)+ylab("counts")+
      scale_shape_manual(values=c(1,19))+ggtitle("RNAseq")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", input$gene, "is not in dataset"))
  }
}

plotSubset=function(input){
  if (! is.na(match(input$gene, rownames(subset)))){
  theme_set(theme_bw())
  df=list()
  df$y=subset[input$gene,]
  df$x=1:length(df$y)
  df$col=subset.f
  df=as.data.frame(df)
  p<-ggplot(df, aes(x=col,
                    y=y, 
                    color=col, 
                    ymin=mean(y),
                    ymax=mean(y)))+
    geom_pointrange(size=2)+ylab("log2 Intensity")+
    ggtitle("SubsetArray")+theme(text = element_text(size=20))
  print(p)
  }
  else{
    grid.text(label=paste("Gene:", input$gene, "is not in dataset"))
  }
}

plotGC=function(input){
  if (! is.na(match(input$gene, rownames(dataGC)))){
    theme_set(theme_bw())
    df=list()
    df$y=dataGC[input$gene,]
    df$x=1:length(df$y)
    df$col=dataGC.f
    df=as.data.frame(df)
    p<-ggplot(df, aes(x=col,
                      y=y, 
                      color=col, 
                      ymin=mean(y),
                      ymax=mean(y)))+
      scale_color_brewer(palette="Set1")+
      geom_pointrange(size=2)+ylab("log2 Intensity")+
      ggtitle("GC Array")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", input$gene, "is not in dataset"))
  }
}


plotGCmiseq=function(input){
  if (! is.na(match(input$gene, rownames(GCmiSeqData)))){
    theme_set(theme_bw())
    df=list()
    df$y=GCmiSeqData[input$gene,]
    df$x=1:length(df$y)
    df$col=GCmiSeqFacts
    df=as.data.frame(df)
    p<-ggplot(df, aes(x=col,
                      y=y, 
                      color=col, 
                      ymin=mean(y),
                      ymax=mean(y)))+
      scale_color_brewer(palette="Set2")+
      guides(fill=FALSE)+
      geom_pointrange(size=2)+ylab("Transformed Counts")+
      ggtitle("GC miSeq")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", input$gene, "is bellow threshold"))
  }
}

shinyServer(function(input, output, session) {
  
  
  output$plotGCmiseq=renderPlot( 
    plotGCmiseq(input)
  )
output$plotRS=renderPlot( 
plotRS(input)
  )
output$plotSubset=renderPlot(
  plotSubset(input)
  )
output$plotGC=renderPlot(
  plotGC(input)
)
  updateTypeAhead(session, inputId = "gene", label = "Look up gene (Human symbol):", choices = geneSet)
  
})