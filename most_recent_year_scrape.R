mostRecentYear <- function(yr){
  
  loginfo("Loading libraries")
  
  suppressMessages(library(tidyverse))
  suppressMessages(library(rvest))
  suppressMessages(library(stringr))
  suppressMessages(library(XML))
  
  source("get_page.R")
  
  url_pg <- paste0('https://www.basketball-reference.com/leagues/NBA_', yr, '_per_game.html')
  url_adv <- paste0('https://www.basketball-reference.com/leagues/NBA_', yr, '_advanced.html')
  
  loginfo(paste("URL counting data:",url_pg))
  loginfo(paste("URL advanced data:",url_adv))
  
  loginfo("scraping per game data")
  
  pg_data <- get_page(url_pg)
  pg_data_html <- html_table(pg_data)
  pg_data_text <- as.data.frame(pg_data_html)
  
  loginfo("scraping advanced data")
  
  adv_data <- get_page(url_adv)
  adv_data_html <- html_table(adv_data)
  adv_data_text <- as.data.frame(adv_data_html)
  
  loginfo('naming advanced data')
  
  names(adv_data_text) <- c("Rk","Player","Pos", "Age", "Tm", "G", "Tot_MP", "PER", "TS_per", "3PAr", "FTr", "ORB_per", "DRB_per", "TRB_per", "AST_per", "STL_per", "BLK_per", "TOV_per", 
                            "USG_per", "del1", "OWS", "DWS", "WS", "WS_48", "del2", "OBPM", "DBPM", "BPM" , "VORP")
  
  loginfo("dropping redundant columns")
  
  adv_data_text2 <- subset(adv_data_text, select = -c(Pos, Age, G, Rk, del1, del2))
  
  loginfo('merging advanced and per game data')
  
  nba <- merge(pg_data_text, adv_data_text2, by = c('Player','Tm'))
  nba <- nba[-which(nba$Player == "Player"), ]
  nba$Pos <- substr(nba$Pos, 1, 2)
  nba$Pos <- str_replace_all(nba$Pos, "[[:punct:]]", "")
  nba <- subset(nba, select = -c(Rk))
  names(nba) <- c("Player", "Tm", "Pos", "Age", "G" , "GS", "MPG", "FG", "FGA", "FG_per", "3P", "3PA", "3P_per", "2P", "2PA", "2P_per", "eFG_per", "FT", "FTA", "FT_per", "ORB", "DRB", "TRB", 
                  "AST", "STL", "BLK", "TOV", "PF", "PTS", "Tot_MP", "PER", "TS_per", "3PAr", "FTr", "ORB_per", "DRB_per", "TRB_per", "AST_per", "STL_per", "BLK_per", "TOV_per", "USG_per", 
                  "OWS", "DWS", "WS", "WS_48", "OBPM", "DBPM", "BPM", "VORP")
  nba$year <- yr
  
  return(nba)
}