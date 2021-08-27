cleanup <- function(ddata){
  
  p3 <- ddata
  
  loginfo("removing one year players and rookies")
  
  # dropping records where the player only appears once
  p4 <- p3 %>%
    arrange(Player, year) %>% 
    group_by(Player) %>% 
    filter(!n() ==1)
  
  loginfo("player trades cause problems. Time to remove.")
  
  # removing when player name/year combo is more than 1 because the year thing causes issues 
  player_names <- paste0(p4$Player, p4$year)
  name_count <- data.frame(table(player_names))
  p4 <- p4[-which(name_count$Freq > 1), ]
  
  return(p4)
}