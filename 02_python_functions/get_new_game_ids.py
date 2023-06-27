import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
 
from nba_api.stats.endpoints import teamgamelogs
 
def get_new_game_ids():
    # no input
    old_gids = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/game_ids.csv") # 
    y1 = (datetime.datetime.today() - datetime.timedelta(days = 365)).strftime('%Y')
    y2 = datetime.datetime.today().strftime('%y')
    current_gids = y1+'-'+y2
    if any(old_gids['SEASON_YEAR'].str.contains(current_gids)):
        print ("No new Game IDs to add. No update required.")
    else:
        new_gids = teamgamelogs.TeamGameLogs(season_nullable=current_gids).get_data_frames()[0][['SEASON_YEAR','TEAM_ID','GAME_ID']]
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/game_ids_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv" 
        old_gids.to_csv(old_file_id, index=False)
        new_gids['GAME_ID'] = 'G'+new_gids['GAME_ID']
        updated_gids = pd.concat([old_gids,new_gids])
        updated_gids.to_csv('/users/jordanwegner/Desktop/nba2/03_data/game_ids.csv',index=False) 

