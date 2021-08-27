#' ---
#' title: NBA Playoff Prediction
#' date: '`r strftime(Sys.time(), format = "%B %d, %Y")`'
#' author: Jordan Wegner
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     theme: united
#' params:
#'  year:
#'    value: x
#'  skipscrape:
#'    value: x
#' 
#' ---

#+ setup, echo = F

year <- as.character(params$year)
skipscrape <- as.character(params$skipscrape)

# Set up logging
library(logging)
logReset()
runId <- paste0("/Users/jordanwegner/Desktop/nba2/logs/",Sys.Date()," run.log")

# output log info to console
basicConfig()
addHandler(writeToFile, file=runId)
loginfo(paste("runId:",runId))

upcomingSeason <- as.character(as.integer(year)+1)
seasonID <- paste0(year,upcomingSeason)

loginfo("New Season")
loginfo(paste("Year:",year))

# scraping new rosters
loginfo("scraping upcoming season rosters")
source('new_roster_scrape.R')
rosters <- newRosters(year)
loginfo("roster scrape complete")

if (skipscrape=="Yes"){
  
  source("skipscrape.R")
  
} else if (skipscrape=="No"){
  
  # scraping most recent year data 
  source('most_recent_year_scrape.R')
  nba <- mostRecentYear(year)
  loginfo(paste(year, 'data scrape complete'))
  
  # getting playoff counts 
  source("playoff_counts_scrape.R")
  pwins <- playoffCounts(year)
  
  # getting data before current season 
  source("loading_history.R")
  histNBA <- historyUntilNow(year)
  
}

# combining old and new data 
source("data_merging.R")
players <- oldNew(histNBA,nba)

# writing data out with new season
source("writing_new_data.R")
writingNew(players, year)

# adding current team via new rosters 
source("new_teams.R")
p3 <- newTeam(players,rosters)

# cleaning up rookies, single year players, and traded players who cannot be lagged 
# IMP potential
source("cleanup.R")
p4 <- cleanup(p3)

# lagging by one year
source("lagging.R")
bound_test <- lagging(p4)

# set with no rookies for comparison 
source("no_rookies.R")
nba_comp_no_rooks <- noRooks(bound_test)

# set with rookies -- cleaning the names to match, setting the missing to 0 
loginfo("creating set that keeps the rookies")
nba_comp_w_rooks <- janitor::clean_names(bound_test)
nba_comp_w_rooks[is.na(nba_comp_w_rooks)] <- 0

# writing out the lagged sets (rookies and no rookies)
source("lagged_writing.R")
laggedWriting(nba_comp_no_rooks,nba_comp_w_rooks,year)

# aggregating data 
source("aggregating.R")
loginfo("aggregating no rookies data set")
nba_agg2NR <- aggregating(nba_comp_no_rooks)
loginfo("aggregating rookies included data set")
nba_agg2R <- aggregating(nba_comp_w_rooks)

# for set with rookies, have to drop year == 2000 (all 0s)
nba_agg2R <- nba_agg2R %>% filter(!age_prior == 0)

# correcting NOK to NOH (Hurrican Katrina)
source("nok_correction.R")
loginfo("changing NOK to NOH (Hurrican Katrina) -- no rookies")
nba_agg2NR <- NOK(nba_agg2NR)
loginfo("changing NOK to NOH (Hurrican Katrina) -- rookies")
nba_agg2R <- NOK(nba_agg2R)

# adding wins 
source("adding_wins.R")
loginfo("adding playoff wins to no rookies data set")
nba2NR <- addWins(nba_agg2NR)
loginfo("adding playoff wins to data set with rookies")
nba2R <- addWins(nba_agg2R)

loginfo("writing modeling data sets to .csv")
write.csv(nba2NR, paste0("modeling_no_rookies_",seasonID,".csv"), row.names = F)
write.csv(nba2R, paste0("modeling_with_rookies_",seasonID,".csv"), row.names = F)

#+ text, echo=F
#'
#'Just a test of text 














