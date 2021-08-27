historyUntilNow <- function(year){
  
  upcomingSeason <- as.character(as.integer(year)+1)
  lastSeason <- as.character(as.integer(year)-1)
  seasonID <- paste0(year,upcomingSeason)
  lastSeasonID <- paste0(lastSeason,year)
  
  prev_season <- paste0("players_",lastSeasonID,".csv")
  
  loginfo(paste("loading",prev_season))
  
  histNBA <- read.csv(prev_season)
  
  # dropping index
  histNBA <- histNBA %>% subset(select=-X)
  
  # renaming the columns
  colnames(histNBA) <- c("Player", "Tm", "Pos", "Age", "G" , "GS", "MPG", "FG", "FGA", "FG_per", "3P", "3PA", "3P_per", "2P", 
                         "2PA", "2P_per", "eFG_per", "FT", "FTA", "FT_per", "ORB", "DRB", "TRB", "AST", "STL", "BLK", "TOV", "PF", 
                         "PTS", "Tot_MP", "PER", "TS_per", "3PAr", "FTr", "ORB_per", "DRB_per", "TRB_per", "AST_per", "STL_per", "BLK_per", "TOV_per", "USG_per", 
                         "OWS", "DWS", "WS", "WS_48", "OBPM", "DBPM", "BPM", "VORP", "year")
  
  return(histNBA)
  
  loginfo('load complete')

}
