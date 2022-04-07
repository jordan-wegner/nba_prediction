# new roster scraping

newRosters <- function(year){
  
  suppressMessages(library(tidyverse))
  suppressMessages(library(rvest))
  suppressMessages(library(stringr))
  suppressMessages(library(XML))
  
  # Original Website
  base_url <- "https://www.basketball-reference.com"
  
  # adding year to current season to get upcoming rosters 
  # year = '2021'
  upcomingSeason <- as.character(as.integer(year)+1)
  seasonID <- paste0(year,upcomingSeason)
  
  
  # getting the tail urls for every team roster 
  pages <- read_html(file.path(base_url)) %>%
    html_nodes("#teams .left a") %>%
    html_attr("href") %>%
    str_replace(year, upcomingSeason)
  
  # creating full urls 
  pages <- paste0(base_url, pages)
  
  # getting only the teams 
  teams <- str_sub(pages, nchar(pages) - 12, nchar(pages) - 10)
  
  rost <- list()
  
  # setting up roster table
  for (i in 1:length(pages)){
    roster <- read_html(pages[i]) %>%
      html_nodes('#roster') %>%
      html_table(header = T)
    roster <- as.data.frame(roster)
    roster$Tm <- teams[i]
    rost[[i]] <- roster
  }
  
  # binding all together 
  rosters <- do.call(rbind, rost)
  
  # getting only the player and team
  rosters <- rosters %>% select(Player, Tm)
  
  # labelling them for the upcoming season
  rosters$year <- upcomingSeason
  
  write.csv(rosters, paste0("rosters_",seasonID,".csv"), row.names = F)
  
  return(rosters)
}