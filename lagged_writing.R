# lagged data writing

laggedWriting <- function(norookies, wrookies, year){
  
  year1 <- year
  year2 <- as.character(as.integer(year)+1)
  year1year2 <- paste0(year1,year2)
  
  loginfo("writing lagged data sets")
  
  nrName <- paste0("per_game_and_advanced_lagged_no_rookies_",year1year2,".csv")
  rName <- paste0("per_game_and_advanced_lagged_with_rookies_",year1year2,".csv")
  
  loginfo(paste0("writing ",nrName))
  write.csv(norookies, nrName, row.names = F)
  loginfo(paste0("writing ",rName))
  write.csv(wrookies, rName, row.names = F)
  
}
