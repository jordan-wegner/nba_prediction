ABswitch <- function(longteam){
  
  pwins <- longteam
  
  # manually switching the team to their abbreviation 
  pwins$tm[which(pwins$tm == 'Atlanta Hawks')] <- 'ATL'
  pwins$tm[which(pwins$tm == 'Boston Celtics')] <- 'BOS'
  pwins$tm[which(pwins$tm == "Brooklyn Nets")] <- 'BRK'
  pwins$tm[which(pwins$tm == "Charlotte Bobcats")] <- 'CHA'
  pwins$tm[which(pwins$tm == "Charlotte Hornets")] <- 'CHH'
  pwins$tm[which(pwins$tm == "Chicago Bulls")] <- 'CHI'
  pwins$tm[which(pwins$tm == "Cleveland Cavaliers")] <- 'CLE'
  pwins$tm[which(pwins$tm == "Dallas Mavericks")] <- 'DAL'
  pwins$tm[which(pwins$tm == "Denver Nuggets")] <- 'DEN'
  pwins$tm[which(pwins$tm == "Detroit Pistons")] <- 'DET'
  pwins$tm[which(pwins$tm == "Golden State Warriors")] <- 'GSW'
  pwins$tm[which(pwins$tm == "Houston Rockets")] <- 'HOU'
  pwins$tm[which(pwins$tm == "Indiana Pacers")] <- 'IND'
  pwins$tm[which(pwins$tm == "Los Angeles Clippers")] <- 'LAC'
  pwins$tm[which(pwins$tm == "Los Angeles Lakers")] <- 'LAL'
  pwins$tm[which(pwins$tm == "Memphis Grizzlies")] <- 'MEM'
  pwins$tm[which(pwins$tm == "Miami Heat")] <- 'MIA'
  pwins$tm[which(pwins$tm == "Milwaukee Bucks")] <- 'MIL'
  pwins$tm[which(pwins$tm == "Minnesota Timberwolves")] <- 'MIN'
  pwins$tm[which(pwins$tm == "New Jersey Nets")] <- 'NJN'
  pwins$tm[which(pwins$tm == "New Orleans Hornets")] <- 'NOH'
  pwins$tm[which(pwins$tm == "New Orleans Pelicans")] <- 'NOP'
  pwins$tm[which(pwins$tm == "New York Knicks")] <- 'NYK'
  pwins$tm[which(pwins$tm == "Oklahoma City Thunder")] <- 'OKC'
  pwins$tm[which(pwins$tm == "Orlando Magic")] <- 'ORL'
  pwins$tm[which(pwins$tm == "Philadelphia 76ers")] <- 'PHI'
  pwins$tm[which(pwins$tm == "Phoenix Suns")] <- 'PHO'
  pwins$tm[which(pwins$tm == "Portland Trail Blazers")] <- 'POR'
  pwins$tm[which(pwins$tm == "Sacramento Kings")] <- 'SAC'
  pwins$tm[which(pwins$tm == "San Antonio Spurs")] <- 'SAS'
  pwins$tm[which(pwins$tm == "Seattle SuperSonics")] <- 'SEA'
  pwins$tm[which(pwins$tm == "Toronto Raptors")] <- 'TOR'
  pwins$tm[which(pwins$tm == "Utah Jazz")] <- 'UTA'
  pwins$tm[which(pwins$tm == "Washington Wizards")] <- 'WAS'
  
  return(pwins)
  
}