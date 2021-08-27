# get page function used for scraping 

get_page <- function(url){
  page <- read_html(url)
  Sys.sleep(sample(seq(.25,2.5,.25),1))
  page
}