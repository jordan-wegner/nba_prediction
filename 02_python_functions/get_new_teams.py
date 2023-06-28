import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
 
from nba_api.stats.static import teams
 
def get_new_teams():
    # no input
    old_teams = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/teams.csv")
    # test addition
    new_teams = pd.DataFrame(teams.get_teams())
    #tp = pd.DataFrame({'id':[1,0], 'full_name': ['J-Crew', 'Wegner Clan'],'abbreviation':['JC', 'WEG'], 'nickname':['J-Crew', 'Wegner Clan'], 'city':['Dallas', 'San Angelo'], 'state':['Texas','Texas'],year_founded':[2021,1990]})  
    #new_teams = pd.concat([new_teams,tp])
    if old_teams.shape[0]>=new_teams.shape[0]:
        print ("No new teams to add. No update required.")
    else:
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/teams_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv"
        old_teams.to_csv(old_file_id, index=False)
        new_teams = new_teams[~new_teams['id'].isin(old_teams['id'])].copy()
        updated_teams = pd.concat([old_teams, new_teams])
        print ("{} new teams added to the data set.".format(new_teams.shape[0]))
        print ("teams.csv now has {} teams.".format(updated_teams.shape[0]))
        updated_teams.to_csv('/users/jordanwegner/Desktop/nba2/03_data/teams.csv',index=False)
 
