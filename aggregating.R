aggregating <- function(fulldata){
  
  modeling <- fulldata
  
  modeling$team <- paste0(modeling$tm, '_', modeling$year)
  
  nba_agg <- aggregate(modeling, by = list(modeling$team), mean)
  
  suppressMessages(library(dplyr))
  
  nba_agg2 <- nba_agg %>% subset(select = -c(player, tm, year, team))
  
  return(nba_agg2)
  
}