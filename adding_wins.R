# adding wins 

addWins <- function(winless){
  
  nba <- winless
  
  nba <- nba %>% dplyr::rename(tm = Group.1)
  
  nbawins <- left_join(nba, pwins, by = 'tm')
  
  loginfo("setting non-playoff teams win total to 0 for both data sets and cleaning current season names")
  
  nbawins$won[is.na(nbawins$won)] <- 0
  nbawins$season <- as.numeric(str_sub(nbawins$tm, nchar(nbawins$tm) -3, nchar(nbawins$tm)))
  
  return(nbawins)
  
}