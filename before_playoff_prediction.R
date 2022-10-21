# before playoff prediction 

year = "2021"
upcomingSeason = as.character(as.integer(year)+1)
model_name = 'pcr_model.rds'
num_comp = 47

source("most_recent_year_scrape.R")
df=mostRecentYear(year)

df2 <- df %>%
  arrange(Player, year) %>% 
  group_by(Player) %>% 
  filter(n() ==1)

df2$tm = paste0(df2$Tm,'_',df2$year)

df3 = df2 %>% subset(select = -c(Player,Tm,Pos,year))

write.csv(df3,"format_correction_do_not_delete.csv")
df3 = read.csv("format_correction_do_not_delete.csv",row.names = 1)

source("no_rookies.R")
df3 <- noRooks(df3)

nba_agg <- aggregate(df3, by = list(df3$tm), mean)

nba = nba_agg %>% subset(select = -c(tm)) %>% dplyr::rename(tm = Group.1)

suppressMessages(library(dplyr))
suppressMessages(library(stringr))

set_year <- nba %>% select(-c(tm))

colnames(set_year) = paste0(colnames(set_year),'_prior')

model <- readRDS(model_name)


suppressMessages(library(pls))

model_predictions <- as.data.frame(predict(model, set_year, ncomp = num_comp))

colnames(model_predictions) <- c('predicted')
model_predictions$team <- nba$tm
model_predictions$ab <- str_sub(nba$tm, 1, nchar(nba$tm) - 5)


conf <- readxl::read_excel('team_conf.xlsx')

pred_year <- merge(model_predictions, conf, by = 'ab')

suppressMessages(library(sqldf))

predictions_year <- sqldf('SELECT * FROM pred_year
      ORDER BY conference, predicted DESC')
colnames(predictions_year) <- c('ab','pred','team_year','team','conf','div')


write.csv(predictions_year, paste0("/Users/jordanwegner/Desktop/nba2/predictions/", Sys.Date(), '-PLAYOFFS-predictions.csv'))

ec_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE conf = 'East' 
                  ORDER BY pred DESC 
                  LIMIT 1")
atl_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Atlantic' 
                  ORDER BY pred DESC 
                  LIMIT 1")
se_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Southeast' 
                  ORDER BY pred DESC 
                  LIMIT 1")
ce_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Central' 
                  ORDER BY pred DESC 
                  LIMIT 1")

wc_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE conf = 'West' 
                  ORDER BY pred DESC 
                  LIMIT 1")
nw_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Northwest' 
                  ORDER BY pred DESC 
                  LIMIT 1")
pac_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Pacific' 
                  ORDER BY pred DESC 
                  LIMIT 1")
sw_champ <- sqldf("SELECT team FROM predictions_year 
                  WHERE div = 'Southwest' 
                  ORDER BY pred DESC 
                  LIMIT 1")
nba_champ <- sqldf("SELECT team FROM predictions_year 
                  ORDER BY pred DESC 
                  LIMIT 1")

print(paste('Atlantic Division Champion:',atl_champ))  
print(paste('Southeast Division Champion:',se_champ))  
print(paste('Central Division Champion:',ce_champ))  
print(paste('Northwest Division Champion:',nw_champ))  
print(paste('Southwest Division Champion:',sw_champ))  
print(paste('Pacific Division Champion:',pac_champ))  

print(paste('EASTERN CONFERENCE CHAMPION:',ec_champ))  
print(paste('WESTERN CONFERENCE CHAMPION:',wc_champ))  

print(paste('NBA CHAMPION:',wc_champ))  
