import pandas as pd
import numpy as np
import datetime 
from datetime import timedelta 

from nba_api.stats.static import players

def get_new_players():
    # no input 
    old_players = pd.read_csv('/users/jordanwegner/Desktop/nba2/03_data/players.csv')
    # test addition
    new_players = pd.DataFrame(players.get_players())
    #tp = pd.DataFrame({'id':[1,0],'full_name':['Jordan Wegner','Jessica Shalkowski'],'first_name':['Jordan','Jessica'],'last_name':['Wegner','Shalkowski'],'is_active':['FALSE','TRUE']})
    #new_players = pd.concat([new_players,tp])
    if old_players.shape[0]>=new_players.shape[0]:
        print("No new players to add. No update required.")
    else:
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/players_"+(datetime.datetime.today()-timedelta(1)).strftime('%Y%m%d')+".csv"
        old_players.to_csv(old_file_id,index=False)
        new_players = new_players[~new_players['id'].isin(old_players['id'])].copy()
        updated_players = pd.concat([old_players,new_players])
        print("{} new players added to the data set.".format(new_players.shape[0]))
        print("players.csv now has {} players.".format(updated_players.shape[0]))
        updated_players.to_csv('/users/jordanwegner/Desktop/nba2/03_data/players.csv',index=False)

