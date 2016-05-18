####################################################################
library(V8)
library(rvest)
library(stringr)

####################################################################
source("wirtualnapolska.R")
source("helpers.R")

####################################################################

# download main page
frm <- getMainPage()
# add article text
articles <- sapply(frm$url, getArticleText, USE.NAMES = FALSE, simplify = FALSE)
frm$articles <- as.character(articles)
frm$title <- cleanText(frm$title)

#remove stop words from article text & title
stop.list <- lapply(c("title", "articles"), function(i, x, stopwords){
  sapply(x[[i]], removeStopwords, stopwords, USE.NAMES = FALSE)
}, x = frm, stopwords)

# check
# data.frame(before = str_length(frm$title), after = str_length(stop.list[[1]]))
# data.frame(before = str_length(frm$articles), after = str_length(stop.list[[2]]))

frm$title <- stop.list[[1]]
frm$articles <- stop.list[[2]]



###### save output to .rds
saveRDS(frm, "output_data.rds")

