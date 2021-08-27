# writing new data 

writingNew <- function(data, year){
  
  # adding year to current season to get upcoming rosters 
  upcomingSeason <- as.character(as.integer(year)+1)
  seasonID <- paste0(year,upcomingSeason)
  
  loginfo(paste0("writing players_",seasonID,".csv"))
  
  new_season <- paste0("players_",seasonID,".csv")
  
  write.csv(data,new_season)
}