import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
 
def get_new_seasons():
    # no input
    old_seasons = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/seasons.csv")
    y1 = datetime.datetime.today().strftime('%Y')
    Y2 = (datetime.datetime.today() - datetime.timedelta(days = -365)).strftime('%Y')
    y2 = (datetime.datetime.today() - datetime.timedelta(days = -365)).strftime('%y')
    current_seasons = y1+'-'+y2
    if any(old_seasons['id'].str.contains(current_seasons)):
        print ("No new seasons to add. No update required.")
    else:
        updated_seasons = pd.concat([old_seasons,pd.DataFrame({'id':current_seasons,'y1':y1,'y2':Y2},index=[0])]).reset_index(drop=True)
        print("Last 5 seasons (in case it's been more than a year): ")
        print(updated_seasons.tail())
        if (int(y1)-int(updated_seasons['y1'][len(updated_seasons)-2]))!=1:
            raise TypeError("Error in Seasons!")
        else:
            old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/seasons_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv" 
            old_seasons.to_csv(old_file_id, index=False)
            updated_seasons.to_csv('/users/jordanwegner/Desktop/nba2/03_data/seasons.csv',index=False) 
