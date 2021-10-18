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
  p4$player_names <- player_names
  name_count <- data.frame(table(player_names))
  p5 <- left_join(p4, name_count, by = c("player_names" = "player_names"))
  p5 <- p5[-which(p5$Freq > 1), ]

  return(p5)
}