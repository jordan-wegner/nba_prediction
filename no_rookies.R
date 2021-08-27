# no rookies

noRooks <- function(laggedData){
  
  bound_test <- laggedData
  
  loginfo("creating data set that drops players with no prior year, ie rookies")
  
  nba_comp_no_rooks <- bound_test[complete.cases(bound_test), ]
  nba_comp_no_rooks <- janitor::clean_names(nba_comp_no_rooks)
  
  dim(nba_comp_no_rooks)
  
  return(nba_comp_no_rooks)
  
}