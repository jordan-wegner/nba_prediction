import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
 
from nba_api.stats.endpoints import teamyearbyyearstats
 
def get_new_playoff_wins():
    # no input
    old_pwins = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv") 
    y1 = (datetime.datetime.today() - datetime.timedelta(days = 365)).strftime('%Y')
    y2 = datetime.datetime.today().strftime('%y')
    current_pwins = y1+'-'+y2
    if any(old_pwins['YEAR'].str.contains(current_pwins)):
        print ("No new playoff wins to add. No update required.")
    else:
        new_pwins = teamyearbyyearstats.TeamYearByYearStats(team_id=current_pwins).get_data_frames()[0]
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/playoff_wins_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv" 
        old_pwins.to_csv(old_file_id, index=False)
        updated_pwins = pd.concat([old_pwins,new_pwins])
        updated_pwins.to_csv('/users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv',index=False) 

