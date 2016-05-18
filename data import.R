library(jsonlite)

gp.items <- fromJSON("data/gazeta_items.json")
se.items <- fromJSON("data/se_items.json")
nd.items <- fromJSON("data/nd_items.json")

gp.items$source <- "Gazeta Polska"
se.items$source <- "Super Express"
nd.items$source <- "Nasz Dziennik"

frm <- rbind(gp.items, se.items, nd.items)
frm$link <- NULL

rm(gp.items)
rm(nd.items)
rm(se.items)

#saveRDS(frm, "data/merged_articles.rds")
#frm <- readRDS("data/merged_articles.rds")
