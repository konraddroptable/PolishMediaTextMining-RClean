library(fastmatch)
library(dplyr)
library(stringr)

source("data import.R")

removePolishChars <- function(txt){
  return(str_replace_all(txt,
                         c("ą"="a", "ć"="c", "ę"="e", "ł"="l", "ń"="n", "ó"="o", "ś"="s", "ź"="z", "ż"="z")))
}

head.sample <- function(x, n = 5){
  set.seed(1)
  if(class(x) == "data.frame"){
    return(x[sample.int(n = nrow(x), size = n, replace = FALSE), ])
  } else{
    return(x[sample.int(n = length(x), size = n, replace = FALSE)])
  }
}


#to lowercase
small.title <- str_to_lower(frm$title)
frm$date <- str_to_lower(frm$date)
small.text <- str_to_lower(frm$text)

#remove polish chars
text.pl <- removePolishChars(small.text)
title.pl <- removePolishChars(small.title)

#only letters
text <- cleanText(text.pl)
title <- cleanText(title.pl)

#word stemming
lemmatization <- readRDS("data/lemmatization.rds")

title.stem.list <- str_split(title, " ")
text.stem.list <- str_split(text, " ")

title.stem <- lapply(title.stem.list, fastStemwords)
text.stem <- lapply(text.stem.list, fastStemwords)

#stopwords -> removeStopwords()
title.stop <- lapply(title.stem, fastRemoveStopwords, stopwords)
text.stop <- lapply(text.stem, fastRemoveStopwords, stopwords)



## output after lemmatization:
unique(frm$source)

dates_gp <- unlist(str_match_all(frm$date[frm$source == "Gazeta Polska"], "[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}"))


dates_se <- sapply(str_match_all(frm$date[frm$source == "Super Express"], 
                                 "[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}"), 
                   function(x){
  paste(str_sub(x[[1]], -2, -1), str_sub(x[[1]], 6, 7), str_sub(x[[1]], 1, 4), sep = ".")
})

nd <- unlist(str_match_all(frm$date[frm$source == "Nasz Dziennik"], "[0-9]{1,2} ?[a-z|ąęćłńóśźż]+ ?[0-9]{4}"))


nd.months <- str_replace_all(nd,
                c("kwietnia"="04", "marca"="03", "lutego"="02", 
                  "stycznia"="01", "grudnia"="12", "listopada"="11", 
                  "października"="10", "września"="09",
                  "sierpnia"="08", "lipca"="07", "czerwca"="06", "maja"="05"))

dates_nd <- str_replace_all(nd.months, " ", ".")


dates <- c(dates_gp, dates_se, dates_nd)

unique(str_length(dates))

dates[str_length(dates) == 9] <- paste("0", dates[str_length(dates) == 9], sep = "")


dates.frm <- dates
title.frm <- sapply(title.stop, function(x) paste(x, collapse = " "))
text.frm <- sapply(text.stop, function(x) paste(x, collapse = " "))
source.frm <- frm$source


output.data <- data.frame(date = dates.frm, title = title.frm, text = text.frm, source = source.frm,
                          stringsAsFactors = FALSE)


output.data$source[output.data$source == "Gazeta Polska"] <- "Gazeta_Polska"
output.data$source[output.data$source == "Nasz Dziennik"] <- "Nasz_Dziennik"
output.data$source[output.data$source == "Super Express"] <- "Super_Express"
unique(output.data$source)

#saveRDS(output.data, "cleanText.rds")

write.table(output.data, "c:/Users/konrad.mrozewski/Desktop/Python scripts/data/clean_articles.csv",
            sep = ";", row.names = FALSE, na = "")



output.data[14961, "title"]


