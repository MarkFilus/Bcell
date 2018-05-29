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
      geom_pointrange(size=2)+ylab("Transformed Counts")+
      ggtitle("GC miSeq")+theme(text = element_text(size=20))
    print(p)
  }
  else{
    grid.text(label=paste("Gene:", input$gene, "is bellow threshold"))
  }
}