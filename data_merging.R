# combining old and new data 

oldNew <- function(oldData, newData){
  
  loginfo("combining previous seasons with current (just finished) season")
  
  histNBA <- oldData
  nba <- newData
  
  # binding data together
  histNBA_and_current <- rbind(histNBA,nba)
  
  # writing data to correct format (characters -> numbers)
  write.csv(histNBA_and_current, "format_correction_do_not_delete.csv",row.names = F)
  
  # reading data back in
  players <- read.csv("format_correction_do_not_delete.csv")
  
  return(players)
  
  loginfo('combination complete')
}