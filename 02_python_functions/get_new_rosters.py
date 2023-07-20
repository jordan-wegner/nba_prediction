# getting the rosters for every season 
import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
import time

def get_new_rosters(seasons,teams):
    # season file as input to get the current season
    # getting yyyy
    current_season_year = int(seasons.tail(1)['y1'].values)
    # getting yyyy-yy
    current_season = seasons.tail(1)['id'].values
    old_rosters = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/rosters.csv")
    # saving old file to archive
    old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/rosters_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv"
    old_rosters.to_csv(old_file_id,index=False)
    # dropping the current season to get the new rosters 
    old = old_rosters[old_rosters['SEASON'].astype(int)<current_season_year].copy()
    from nba_api.stats.endpoints import commonteamroster
    ctr_list = []
    for i in list(teams['id']):
        ctr_j = commonteamroster.CommonTeamRoster(team_id=i,season=current_season,league_id_nullable='00').get_data_frames()[0]
        ctr_list.append(ctr_j)
        time.sleep(.600) # had to do this to avoid the api timeout
        print("Team: {}, Done.".format(i))
    # should always get rosters for 30 teams 
    if len(ctr_list)!=30:
        raise TypeError("Didn't get 30 teams!")
    # turning into a data frame 
    roster5 = pd.concat(ctr_list)
    # height in inches because excel is stupid 
    print("Getting height in inches")
    height = roster5['HEIGHT'].str.split('-')
    # have to deal with None populations 
    nh = []
    for i in height: 
        if i == None:
            x = ['0','0']
        else: 
            x = i 
        nh.append(x)
    def height_inches(h):
        h1 = int(float(h[0]))
        h2 = int(float(h[1]))
        height = h1*12+h2
        return height
    heights = [height_inches(i) for i in nh]
    roster5['HEIGHT_INCHES'] = heights
    print("height calculation complete")
    updated_rosters = pd.concat([old,roster5])
    updated_rosters.to_csv("/users/jordanwegner/Desktop/nba2/03_data/rosters.csv",index=False)
    
