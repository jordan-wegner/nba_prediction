# playoff counts 

playoffCounts <- function(year){
  
  loginfo(paste("Scraping NBA playoff counts as of the",year,"Finals"))
  
  # list of all teams
  teams <- readxl::read_excel('teams.xlsx')
  
  # playoff results page
  url_pg <- 'https://www.basketball-reference.com/playoffs/series.html'
  
  source("get_page.R")
  
  pg_data <- get_page(url_pg)
  pg_data_html <- html_table(pg_data)
  pg_data_text <- as.data.frame(pg_data_html)
  
  # dropping the useless columns 
  drop <- c(2,4,5,8,11,12,13)
  plf <- pg_data_text[,-drop]
  
  # dropping rows which are blank or gap fillers 
  plf <- plf[-which(plf$Var.1 == ''),]
  plf <- plf[-which(plf$Var.1 == 'Yr'),]
  
  # changing to numeric 
  plf$Var.1 <- as.numeric(plf$Var.1)
  
  # getting only greater than 2000
  plf <- plf %>% filter(Var.1 >= 2000)
  
  # renaming columns
  colnames(plf) <- c('year', 'round', 'winner',
                     'winner_count', 'loser',
                     'loser_count')
  
  # combining year and team to get winners 
  plf$winner <- paste(plf$winner, plf$year)
  plf$loser <- paste(plf$loser, plf$year)
  
  # getting separate winner and loser tables 
  losers <- plf[,c(1,5,6)]
  winners <- plf[,c(1,3,4)]
  
  # renaming both tables 
  colnames(losers) <- c('year', 'team', 'won')
  colnames(winners) <- c('year', 'team', 'won')
  
  # putting them back together 
  plf_new <- rbind(winners, losers)
  suppressMessages(library(sqldf))
  
  # grouping by team and getting total wins
  p_wins <- sqldf("SELECT team, SUM(won) FROM plf_new
      GROUP BY team")
  
  # creating data frame and also grabbing everything outside of the parenthesis 
  pwins <- as.data.frame(gsub("\\s*\\([^\\)]+\\)","",as.character(p_wins$team)))
  colnames(pwins) <- 'tm'
  
  source("substrRight.R")
  
  # getting just the year 
  pwins_year <- substrRight(pwins$tm, 4)
  pwins$year <- pwins_year
  
  # getting everythign to the left of the year 
  pwins$tm <- substr(pwins$tm, 1, nchar(pwins$tm)-4)
  pwins$won <- p_wins$`SUM(won)`
  
  # trimming the white space
  pwins$tm <- str_trim(pwins$tm)
  
  # switching from long team name to abbreviation
  source("abswitch.R")
  pwins <- ABswitch(pwins)
  
  # getting team_year format 
  pwins$tm <- paste0(pwins$tm, '_', pwins$year)
  
  #dropping the year column
  pwins <- pwins %>% subset(select = -year)
  
  loginfo("writing playoff wins data set as playoff_wins.csv")
  
  write.csv(pwins, "playoff_wins.csv", row.names = F)

  return(pwins)
}
