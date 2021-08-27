# lagging performance by one year 
lagging <- function(preLag){
  
  p4 <- preLag
  
  loginfo("lagging performance by one season")
  
  # arranging by player and year and then lagging
  temp <- p4 %>% arrange(Player, year) %>% 
    group_by(Player) %>% 
    mutate_all(lag)
  
  # adding "prior" to the new lagged columns
  colnames(temp) <- paste0(colnames(temp), '_prior')
  
  loginfo("binding current season statistics and prior season statistics")
  
  # column binding the data
  bound_test <- cbind(p4, temp)
  
  loginfo("data check")
  
  bound_test %>% filter(Player == 'Al Horford') %>% subset(select=c(PTS,PTS_prior))

  loginfo("dropping all current season statistics")
  
  keepCols <-  c("Player","Tm","year", "Age_prior",
                 "G_prior","GS_prior","MPG_prior","FG_prior","FGA_prior","FG_per_prior","X3P_prior",
                 "X3PA_prior","X3P_per_prior","X2P_prior","X2PA_prior","X2P_per_prior","eFG_per_prior","FT_prior",
                 "FTA_prior","FT_per_prior","ORB_prior","DRB_prior","TRB_prior","AST_prior","STL_prior",
                 "BLK_prior","TOV_prior","PF_prior","PTS_prior","Tot_MP_prior","PER_prior","TS_per_prior",
                 "X3PAr_prior","FTr_prior","ORB_per_prior","DRB_per_prior","TRB_per_prior","AST_per_prior","STL_per_prior",
                 "BLK_per_prior","TOV_per_prior","USG_per_prior","OWS_prior","DWS_prior","WS_prior","WS_48_prior",
                 "OBPM_prior","DBPM_prior","BPM_prior","VORP_prior")   
  
  bound_test <- bound_test[,keepCols]
  
  return(bound_test)

}