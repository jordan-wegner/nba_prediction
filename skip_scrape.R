# for when scraping gets skipped 

# loading playoff counts and data 

upcomingSeason <- as.character(as.integer(year)+1)
seasonID <- paste0(year,upcomingSeason)

# reading player data 
loginfo(paste0("reading players_",seasonID,".csv"))
players <- read.csv(paste0("players_",seasonID,".csv"))

# reading playoff counts
pwins <- read.csv("playoff_wins.csv")