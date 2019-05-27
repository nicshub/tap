library(tm)
create_model_input <- function(features, text){
  # sanity check on inputs should be included
  #
  # Create the dtm for the input document
  df.tmp <- data.frame('doc_id' = 1, 'text' = text)
  dfs.tmp <- DataframeSource(df.tmp)
  vc.tmp <- VCorpus(dfs.tmp)
  # input data, cleaning
  vc.tmp <- tm_map(vc.tmp, removeNumbers)
  vc.tmp <- tm_map(vc.tmp, removePunctuation)
  vc.tmp <- tm_map(vc.tmp, content_transformer(tolower))
  vc.tmp <- tm_map(vc.tmp, removeWords, c(stopwords("italian")))
  vc.tmp <- tm_map(vc.tmp, stripWhitespace)
  vc.tmp <- tm_map(vc.tmp, stemDocument)  
  # input data, DTM
  dtm.tmp <- DocumentTermMatrix(vc.tmp)
  model_input.tmp <- as.data.frame(as.matrix(dtm.tmp))
  #
  # Use the DTM to create the input with ALL the model features
  # creiamo una matrice con tante colonne quante parole, e tutti 0
  #model_input <- matrix( integer(length(colnames(features))), nrow=1)
  model_input <- matrix( integer(length(features)), nrow=1)
  # popoliamo solo le parole presenti nei dati di test (con tf)
  for (test in seq(1,length(model_input.tmp))){
    model_input[1,features==colnames(model_input.tmp)[test]] <- model_input.tmp[1,test]
  }
  # convertiamo la matrice in data.frame ed aggiungiamo i nomi delle colonne
  model_input <- as.data.frame(model_input)
  names(model_input) <- features
  return(model_input)
}