library(shiny)
#.libPaths("/home/mchikina/R/x86_64-pc-linux-gnu-library/3.4/","/home/mchikina/R/x86_64-pc-linux-gnu-library/3.1/")
#print(.libPaths())
#load("BcellShinyUpdate.RData")
#load("newRNAseq.RData")
#load("dxGCresult.RData")
#load("geneSet.RData")
#load("geneSet2.RData")
#load("Human2Mouse.RData")
#library(ggplot2)
#library(gridExtra)
#library(grid)
#library(RColorBrewer)
#library(DEXSeq)
#source("DEXseqhelper.R")
#splicegenes=unique(sub(":.*","",rownames(dxrGC)))



#library(shinyBS)


plotRS=function(input){
  gene=sub(" - .*","", isolate(input$gene))
  if (! is.na(match(gene, rownames(data)))){
    theme_set(theme_bw())
    df=list()
    
    df$y=data[gene,]
    df$x=1:ncol(data)
    df$col=facts
    df$pop=pop
    df=as.data.frame(df)
    p<-ggplot(df, aes(x=x,y=y, color=col, shape=pop))+geom_point(size=5)+ylab("counts")+
      scale_shape_manual(values=c(1,19))+ggtitle("RNAseq")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", gene, "is not in dataset"))
  }
}

plotSubset=function(input){
  gene=sub(" - .*","", isolate(input$gene))
  if (! is.na(match(gene, rownames(subset)))){
    theme_set(theme_bw())
    df=list()
    df$y=subset[gene,]
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
    grid.text(label=paste("Gene:", gene, "is not in dataset"))
  }
}

plotGC=function(input){
  gene=sub(" - .*","", isolate(input$gene))
  if (! is.na(match(gene, rownames(dataGC)))){
    theme_set(theme_bw())
    df=list()
    df$y=dataGC[gene,]
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
    grid.text(label=paste("Gene:", gene, "is not in dataset"))
  }
}

plotSplicing=function(input){
  gene=sub(" - .*","", isolate(input$gene))
  genem=Human2Mouse[gene,]
  print(genem)
  if (! is.na(match(genem, splicegenes))){
    myplotDEXSeq( dxrGC, genem, legend=TRUE, cex.axis=1.2, cex=1.3, lwd=2.5 , norCounts = F, splicing = T, FDR = 0.1, fitExpToVar="type", cex.main=1)
  }
  else{
    grid.text(label=paste("Gene:", gene, "is not in dataset"))
  }
}

plotGCmiseq=function(input){
  gene=sub(" - .*","", isolate(input$gene))
  if (! is.na(match(gene, rownames(allDat)))){
    theme_set(theme_bw())
    df=list()
    df$y=allDat[gene,]
    df$x=1:length(df$y)
    df$col=allDat.f
    df=as.data.frame(df)
    p<-ggplot(df, aes(x=col,
                      y=y, 
                      color=col, 
                      ymin=mean(y),
                      ymax=mean(y)))+
      scale_color_discrete()+
      guides(fill=FALSE)+  theme(axis.title.x=element_blank(),
                                 axis.text.x=element_blank(),
                                 axis.ticks.x=element_blank())+
      geom_pointrange(size=2)+ylab("Transformed Counts")+
      ggtitle("BulkRNAseq")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", gene, "is bellow threshold"))
  }
}

shinyServer(function(input, output, session) {
  
  
  observeEvent(
    input$reset,
    {print(input$reset);
      updateTypeAhead(session, inputId = "gene", value = "")
    })
  
  observeEvent( input$plot, 
                {
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
                  
                  output$plotSplicing=renderPlot(
                    plotSplicing(input)
                  )
                }
  )
  updateTypeAhead(session, inputId = "gene", label = "Look up gene (Human symbol):", choices = geneSet2)
  
})