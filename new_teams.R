# adding new team 

newTeam <- function(stats, roster){
  
  players <- stats
  rosters <- roster
  
  loginfo("assigning current teams via new roster scrape, cleaning data, and lagging by a season.")
  loginfo("dropping rows with a TOT assignment as a result of being traded")
  
  p2 <- players %>% filter(!Tm == 'TOT')
  
  loginfo("setting missing values to be 0 (assuming they are either percentages or do not occurr in game)")
  
  p2[is.na(p2)] <- 0
  
  loginfo("attaching rosters to players statistics")
  
  p3 <- plyr::rbind.fill(p2, rosters)
  
  return(p3)
  
}