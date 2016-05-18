stopwords <- unique(read.table("stopwords.csv", quote="\"", comment.char="", stringsAsFactors=FALSE)[[1]])
commonwords <- unique(read.table("wordcheck.csv", quote="\"", comment.char="", stringsAsFactors=FALSE)[[1]])

stopwords <- unique(c(stopwords, commonwords))

removeStopwords <- function(txt, stopwordsVector){
  sw <- removePolishChars(stopwordsVector)
  vec <- strsplit(txt, " ")[[1]]
  vec <- vec[str_length(vec) > 3] #only words longer than 3 chars
  
  return(paste(vec[!(vec %in% sw)], collapse = " "))
}

cleanText <- function(txtVector){
  txtVector %>%
    str_replace_all("\n|\r|\t", "") %>% #remove escape chars
    str_replace_all("<.*>", "") %>% #remove html tags
    str_replace_all("[^[:alpha:]]", " ") %>% #only alpha-numeric chars
    str_replace_all(" +", " ") %>% #remove excess whitespaces
    str_replace_all("^ *| *$", "") -> txt #remove leading and trailing whitespaces
  
  return(txt)
}

fastRemoveStopwords <- function(txtVec, stopwords){
  x.leave <- c("usa", "cba", "tvn", "nfz", "zus", "onz", "who", "pis", "po", "sld", "tk")
  txtVec <- txtVec[str_length(txtVec) > 3 | txtVec %in% x.leave]
  
  return(txtVec[is.na(fmatch(txtVec, stopwords))])
}

fastStemwords <- function(txtVec){
  #import lemmatization dictionary before using this function
  idx <- fmatch(txtVec, lemmatization$word) 
  isNA <- is.na(idx)
  
  return(ifelse(isNA, txtVec[isNA], lemmatization$stem[idx]))
}




