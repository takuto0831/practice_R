### get data of new listing on JPX

# load packages
library(rvest)
library(dtplyr)

# get data from url
url <- "http://www.nikkei.com/markets/ranking/page/?bd=betahigh"
url.jp <- "http://www.jpx.co.jp/listing/stocks/new/index.html"
d.html <- xml2::read_html(url, encoding = "utf-8")
d.html.jp <- xml2::read_html(url.jp, encoding = "utf-8")

# scraping "d.html"
d.tbl <- d.html %>%
  rvest::html_table() %>% 
  as.data.frame() %>% 
  dplyr::select(Date.of.Listing, Issue.Name.2, Code, Market.Division.3)

d.tbl.jp <- d.html.jp %>% 
  rvest::html_table() %>% 
  as.data.frame() %>%
  dplyr::select(?????P??) %>% 
  apply(1, function(x){try(as.numeric(x))}) %>% 
  na.omit() %>% 
  as.numeric()

d.tbl.new <- data.frame(d.tbl, d.tbl.jp)
colnames(d.tbl.new) <- c("date", "full name", "id", "division", "lot size")

# write a csv file
write.csv(d.tbl.new, paste0(getwd(), "/new.listing_jpx.csv"), row.names = FALSE)


### delisted

url2 <- "http://www.jpx.co.jp/english/listing/stocks/delisted/index.html"
d.html2 <- xml2::read_html(url2, encoding = "utf-8")

d.tbl2 <- d.html2 %>%
  rvest::html_table() %>% 
  as.data.frame()
colnames(d.tbl2) <- c("date", "full name", "id", "division", "reason")

write.csv(d.tbl2, paste0(getwd(), "/delisted_jpx.csv"), row.names = FALSE)
